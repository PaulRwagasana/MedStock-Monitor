# Security Policy

## Overview

MedStock Monitor integrates automated security scanning into every stage of the CI pipeline. Three scan types run on every pull request and push, ensuring vulnerabilities and misconfigurations are caught before code reaches the main branch. This document records all findings discovered during development, the actions taken, and the reasoning behind every accepted risk.

## Scanning Tools and Coverage

| Tool | Scan Type | CI Job | Blocks Merge on Finding |
|---|---|---|---|
| npm audit | Dependency vulnerabilities | `security-scan` | Yes — HIGH and CRITICAL |
| Trivy | Container image vulnerabilities | `docker-build` | Yes — HIGH and CRITICAL |
| Checkov | IaC misconfiguration | `iac-scan` | No — reports only (soft fail) |

## Severity Thresholds

| Severity | npm audit | Trivy | Checkov |
|---|---|---|---|
| CRITICAL | Fails pipeline | Fails pipeline | Reported in artifact |
| HIGH | Fails pipeline | Fails pipeline | Reported in artifact |
| MEDIUM | Reported only | Reported only | Reported in artifact |
| LOW / INFO | Ignored | Ignored | Reported in artifact |

Checkov uses soft fail because the Terraform configurations use the Docker provider (`kreuzwerker/docker ~> 3.0`) and are under active development. Checkov runs in static analysis mode without any runtime environment, so some findings require context that only exists at apply time. All findings are documented in this file. Hard fail will be enabled before the summative once configurations are stable.

## Scan 1: Dependency Vulnerabilities (npm audit)

**Result: PASSING**

The audit runs against production dependencies only using `--omit=dev --audit-level=high`. DevDependencies  Jest, ESLint, Supertest  are excluded because they never run inside the production container and vulnerabilities in test tooling cannot be exploited through any production code path.

Our application dependencies (`express`, `pg`, `cors`, `dotenv`) returned zero HIGH or CRITICAL findings.

| Package | Severity | Finding | Status |
|---|---|---|---|
| brace-expansion (Jest internal) | HIGH | GHSA-3jxr-9vmj-r5cp — DoS via exponential regex expansion | Accepted risk : devDependency only, excluded from production audit scope |
| All production dependencies | — | No findings | Passing |

## Scan 2: Container Image Vulnerabilities (Trivy)

**Result: PASSING**

Trivy scans the built Docker image for CVEs in OS-level packages and Node modules. The scan is configured with `ignore-unfixed: true` so only vulnerabilities with an available fix are reported, keeping findings actionable rather than noisy.

### OS-level findings : Fixed

Six HIGH and CRITICAL CVEs were found in `libcap2` and `libgnutls30` inside the `node:20-slim` base image on first scan. All were resolved by adding `apt-get update && apt-get upgrade -y` to the Dockerfile production stage, pulling the latest Debian security patches at build time.

| Package | CVE | Severity | Action Taken |
|---|---|---|---|
| libcap2 | CVE-2026-4878 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33845 | CRITICAL | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42010 | CRITICAL | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33846 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-3833 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42009 | HIGH | Fixed via apt-get upgrade |

### npm-internal package findings — Eliminated

On the first scan, Trivy found 12 HIGH CVEs in packages located at `usr/local/lib/node_modules/npm/node_modules/` npm's own internal bundled dependencies, not application code. These packages (`tar`, `minimatch`, `glob`, `cross-spawn`, `sigstore`) are never imported or called by the Express application at runtime, and no HTTP endpoint exposes them.

The initial response was to suppress them via `.trivyignore`. However, when a routine Trivy database refresh surfaced additional CVE IDs against the same underlying packages, it became clear that suppressing individual CVE IDs was a moving target  new disclosures would keep appearing against the same unused component indefinitely.

The root cause was addressed instead by removing npm entirely from the production image:

```dockerfile
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
```

Since the container's only runtime command is `node server.js`, npm was never needed in the final image. Removing it eliminates the entire class of vulnerability. The `.trivyignore` file remains in the repository as an audit trail of what was previously found but is now redundant — the packages no longer exist in the scanned image.

The current scan returns zero HIGH or CRITICAL findings.

## Scan 3: IaC Misconfiguration (Checkov)

**Result: PASSING (with scoped configuration)**

Checkov scans the `terraform/` directory which uses the Docker Terraform provider (`kreuzwerker/docker ~> 3.0`). Azure-specific checks (`CKV_AZURE_*`) are explicitly skipped via `.checkov.yaml` because they target `azurerm` resource types that do not exist in this configuration. Running them would produce false positives against Docker provider resources.

All checks applicable to the Docker provider pass. Full results are uploaded as the `checkov-results` artifact on every CI run for review.

## Remediation Summary

| Action | Tool | Outcome |
|---|---|---|
| `apt-get upgrade` added to Dockerfile production stage | Trivy | Eliminated 6 OS-level CVEs in libcap2 and libgnutls30 |
| npm CLI removed from production image | Trivy | Eliminated entire class of npm-internal CVE findings |
| `ignore-unfixed: true` in Trivy configuration | Trivy | Limits reports to actionable findings with available fixes |
| `--omit=dev` flag on npm audit | npm audit | Scopes audit to production dependencies only |
| Azure checks skipped in `.checkov.yaml` | Checkov | Prevents false positives from checks targeting azurerm resources |
| Multi-stage Dockerfile | Trivy | Build tools absent from production image, reducing attack surface |
| Non-root user (`USER node`) in Dockerfile | All | Limits blast radius if a container vulnerability is exploited |
| `packages: write` permission scoped to docker-build job only | Pipeline | Principle of least privilege on GHCR  other jobs cannot write packages |
| `.env` gitignored, `.env.example` committed | All | No secrets committed to version control |

## Accepted Risks Register

| Risk | Severity | Reason Accepted | Mitigation |
|---|---|---|---|
| brace-expansion HIGH CVE in Jest devDependency | HIGH | Jest is a test-only tool  never runs in production, never ships inside the Docker image, cannot be exploited through any production code path | Excluded from audit scope via `--omit=dev` |
| Checkov soft fail on Docker Terraform configurations | Varies | Configurations are under active development and Checkov's Docker provider rule set is smaller than AWS or Azure — some findings require runtime context not available in static analysis | All findings reviewed manually; hard fail enabled before summative |

## Reporting a Vulnerability

If you discover a security vulnerability in MedStock Monitor, do not open a public GitHub issue. Use GitHub's private vulnerability reporting feature on the Security tab of the repository, or contact the repository owner directly.