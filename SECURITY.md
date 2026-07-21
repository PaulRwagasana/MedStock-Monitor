# Security Policy

## Overview

MedStock Monitor integrates security scanning at every stage of the development
workflow. Three automated scan types run on every pull request and push,
ensuring vulnerabilities and misconfigurations are caught before code reaches
the main branch. This document records all findings, actions taken, and the
reasoning behind every accepted risk.

---

## Scanning Tools & Coverage

| Tool | Scan Type | Trigger | CI Job | Blocks Merge |
|---|---|---|---|---|
| npm audit | Dependency vulnerabilities | Every PR and push | `security-scan` | Yes : HIGH/CRITICAL |
| Trivy | Container image vulnerabilities | Every PR and push | `docker-build` | Yes : HIGH/CRITICAL |
| Checkov | IaC misconfiguration (Terraform) | Every PR and push | `iac-scan` | Reports only (soft fail) |

---

## Severity Thresholds

| Severity | npm audit | Trivy | Checkov |
|---|---|---|---|
| CRITICAL |  Fails pipeline |  Fails pipeline |  Reported in artifact |
| HIGH |  Fails pipeline |  Fails pipeline |  Reported in artifact |
| MEDIUM |  Reported only |  Reported only |  Reported in artifact |
| LOW / INFO |  Ignored |  Ignored |  Reported in artifact |

**Why Checkov uses soft fail:** The Terraform configurations provision
Azure networking infrastructure that requires an active Azure subscription to
validate fully. Checkov runs in static analysis mode and it reads `.tf` files
without cloud credentials. Blocking merges on every Checkov finding in a
development environment would pause collaboration while the infrastructure is
actively being built. All Checkov findings are documented here and addressed
before any production deployment.

---

## Scan 1: Dependency Vulnerabilities (npm audit)

### Result:  PASSING

Our application dependencies : `express`, `pg`, `cors`, `dotenv` :returned
zero HIGH or CRITICAL vulnerabilities. The `security-scan` job passes clean
on every run.

| Package | Severity | CVE | Status |
|---|---|---|---|
| No findings | | All application dependencies are clean |  Passing |

**Why this matters:** npm audit checks every package in `package-lock.json`
against the Node.js Security Advisory database. A clean result here means our
direct application dependencies carry no known exploitable vulnerabilities
at the time of submission.

**Scope:** Production dependencies only (`--omit=dev`). DevDependencies
(Jest, ESLint, Supertest) are excluded from audit since they never run
in the production container. A HIGH finding in `brace-expansion` was
identified in Jest's internal `test-exclude` dependency this is
documented as an accepted risk since it cannot be exploited through
any production code path.

---

## Scan 2: Container Image Vulnerabilities (Trivy)

### Result:  PASSING (after remediation)

Trivy scans the built Docker image for CVEs in OS packages and Node modules.
Configured with `ignore-unfixed: true` so only vulnerabilities with available
fixes are reported  keeping findings actionable.

### OS-level findings  FIXED

Six HIGH and CRITICAL CVEs were found in `libcap2` and `libgnutls30` packages
inside the `node:20-slim` base image. All were resolved by adding
`apt-get update && apt-get upgrade -y` to the Dockerfile production stage,
which pulls the latest Debian security patches at build time.

| Package | CVE | Severity | Fixed Version | Action |
|---|---|---|---|---|
| libcap2 | CVE-2026-4878 | HIGH | 1:2.66-4+deb12u3 |  Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33845 | CRITICAL | 3.7.9-2+deb12u7 |  Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42010 | CRITICAL | 3.7.9-2+deb12u7 |  Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33846 | HIGH | 3.7.9-2+deb12u7 |  Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-3833 | HIGH | 3.7.9-2+deb12u7 |  Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42009 | HIGH | 3.7.9-2+deb12u7 |  Fixed via apt-get upgrade |

### Node.js package findings ACCEPTED RISK (suppressed in .trivyignore)

Twelve HIGH CVEs were found at path `usr/local/lib/node_modules/npm/node_modules/`.
These are **npm's own internal bundled dependencies** not our application
packages. They appear at `/usr/local/lib/` not `/app/node_modules/`, confirming
they belong to the npm tool itself rather than our codebase.

**Original approach vs. final fix:** The initial 12 CVEs were suppressed
via `.trivyignore` with documented reasoning (npm is never invoked at
runtime, container runs as non-root, no endpoint exposes npm). When a
routine Trivy DB refresh surfaced 3 *new* CVE IDs against the same
underlying npm-bundled packages, it confirmed that suppressing by CVE ID
was a moving target new disclosures against the same unused component
would keep appearing indefinitely. We addressed the root cause instead:

```dockerfile
# Remove bundled npm CLI which is unused at runtime to resolve tar/brace-expansion CVEs
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
```

added to the production stage of the Dockerfile, after `COPY . .` and before
`USER node`. Since the container's only runtime command is `node server.js`,
npm was never needed in the final image. Removing it eliminates the entire
class of vulnerability rather than accepting ongoing risk from it.

**Note on `.trivyignore`:** the original 12 CVE entries are now redundant
(the packages they refer to no longer exist in the scanned image) and can
be cleaned up in a future pass  left in place for now since they're
harmless and preserve the audit trail of what was previously found.

**Mitigations in place:**
- npm CLI removed entirely from the production image nothing left to scan or exploit
- Container runs as non-root user (`USER node`) limiting blast radius
- Multi-stage build keeps build-time tooling out of the shipped image

---

| Package | CVE | Severity | Location |
|---|---|---|---|
| cross-spawn 7.0.3 | CVE-2024-21538 | HIGH | npm internal |
| glob 10.4.2 | CVE-2025-64756 | HIGH | npm internal |
| minimatch 9.0.5 | CVE-2026-26996 | HIGH | npm internal |
| minimatch 9.0.5 | CVE-2026-27903 | HIGH | npm internal |
| minimatch 9.0.5 | CVE-2026-27904 | HIGH | npm internal |
| sigstore 2.3.1 | CVE-2026-48815 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-23745 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-23950 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-24842 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-26960 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-29786 | HIGH | npm internal |
| tar 6.2.1 | CVE-2026-31802 | HIGH | npm internal |

**Why these are suppressed:** These packages cannot be updated via
`package.json` : they are internal to the npm binary that ships with
`node:20-slim`. They are never imported or called by our running Express
application. None of these packages are reachable through any HTTP endpoint
our API exposes. They exist solely as tools npm uses during installation,
which does not happen at container runtime. All 12 CVE IDs are listed in
`.trivyignore` with this reasoning documented inline.

**Mitigations in place:**
- Container runs as non-root user (`USER node`) limiting blast radius
- npm is not exposed externally no port or endpoint calls npm at runtime
- Multi-stage build means npm itself could be removed from the final image
  in a future hardening pass by copying only `node_modules` without npm

---

## Scan 3: IaC Misconfiguration (Checkov)

### Result:  PASSING (with scoped configuration)

Checkov scans the `terraform/` directory using the Docker Terraform provider
(kreuzwerker/docker ~> 3.0). Azure-specific checks (CKV_AZURE_*) are skipped
via `.checkov.yaml` since they target azurerm resources that don't exist in
this configuration — running them would produce false positives against
Docker provider resources.

All Docker provider checks pass. Full results are uploaded as
`checkov-results` artifact on every CI run.

**Why soft fail:** Checkov is still being calibrated as Terraform
configurations evolve. Hard fail will be enabled before the summative.

## Remediation Summary

| Action | Scan Type | Result |
|---|---|---|
| `apt-get upgrade` added to Dockerfile | Trivy | Eliminated 6 OS-level CVEs |
| `ignore-unfixed: true` in Trivy config | Trivy | Reports only actionable findings |
| `.trivyignore` for npm-internal CVEs | Trivy | 12 unfixable CVEs suppressed with documentation |
| `npm audit --audit-level=high` threshold | npm audit | Only blocks on genuinely dangerous findings |
| `soft_fail: true` for Checkov | Checkov | Findings documented without blocking dev workflow |
| Multi-stage Dockerfile | Trivy | Build tools absent from production image |
| Non-root user (`USER node`) | All | Limits container exploit blast radius |
| `packages: write` scoped to one job | Pipeline | Principle of least privilege on GHCR |
| `.env` gitignored, `.env.example` committed | All | No secrets in version control |

---

## Accepted Risks Register

| Risk | Severity | Reason Accepted | Mitigation |
|---|---|---|---|
| 12 npm-internal CVEs (tar, minimatch, glob, cross-spawn, sigstore) | HIGH | Not reachable at runtime; cannot be fixed via package.json; internal to npm binary | Non-root user; npm not exposed externally; documented in .trivyignore |
| SSH open to 0.0.0.0/0 in Terraform default | HIGH | Development environment only; variable is configurable for production | Variable override required before any production deployment |
| Checkov soft fail | Varies | Infrastructure actively under development; hard fail would block the team | All findings documented here; hard fail to be enabled before summative |

---
