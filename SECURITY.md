# Security Policy

## Overview

MedStock Monitor integrates automated security scanning into every stage of the CI pipeline. Three scan types run on every pull request and push, ensuring vulnerabilities and misconfigurations are caught before code reaches the main branch. This document records all findings discovered during development, the actions taken, and the reasoning behind every accepted risk.

## Scanning Tools and Coverage

| Tool | Scan Type | CI Job | Blocks Merge on Finding |
|---|---|---|---|
| npm audit | Dependency vulnerabilities | `security-scan` | Yes — HIGH and CRITICAL |
| Trivy | Container image vulnerabilities | `docker-build` | Yes — HIGH and CRITICAL |
| Checkov | IaC misconfiguration | `iac-scan` | Yes — hard fail (soft fail removed for summative) |

## Severity Thresholds

| Severity | npm audit | Trivy | Checkov |
|---|---|---|---|
| CRITICAL | Fails pipeline | Fails pipeline | Fails pipeline |
| HIGH | Fails pipeline | Fails pipeline | Fails pipeline |
| MEDIUM | Reported only | Reported only | Reported only |
| LOW / INFO | Ignored | Ignored | Reported only |

## Scan 1: Dependency Vulnerabilities (npm audit)

**Result: PASSING**

The audit runs against production dependencies only using `--omit=dev --audit-level=high`. DevDependencies are excluded because they never run inside the production container and cannot be exploited through any production code path.

Our application dependencies (`express`, `pg`, `cors`, `dotenv`) returned zero HIGH or CRITICAL findings.

| Package | Severity | Finding | Status |
|---|---|---|---|
| brace-expansion (Jest internal) | HIGH | GHSA-3jxr-9vmj-r5cp — DoS via exponential regex expansion | Accepted risk — devDependency only, excluded from audit scope via --omit=dev |
| All production dependencies | — | No findings | Passing |

## Scan 2: Container Image Vulnerabilities (Trivy)

**Result: PASSING**

Trivy scans the built Docker image for CVEs in OS-level packages and Node modules. Configured with `ignore-unfixed: true` so only vulnerabilities with an available fix are reported.

### OS-level findings — Fixed

Six HIGH and CRITICAL CVEs were found in `libcap2` and `libgnutls30` inside the `node:20-slim` base image. All resolved by adding `apt-get update && apt-get upgrade -y` to the Dockerfile production stage.

| Package | CVE | Severity | Action Taken |
|---|---|---|---|
| libcap2 | CVE-2026-4878 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33845 | CRITICAL | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42010 | CRITICAL | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-33846 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-3833 | HIGH | Fixed via apt-get upgrade |
| libgnutls30 | CVE-2026-42009 | HIGH | Fixed via apt-get upgrade |

### npm-internal package findings — Eliminated

Twelve HIGH CVEs were found in npm's own internal bundled dependencies (`tar`, `minimatch`, `glob`, `cross-spawn`, `sigstore`). These were never reachable through the application. The root cause was addressed by removing npm entirely from the production image:

```dockerfile
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
```

### brace-expansion CVE — Accepted Risk

| Package | CVE | Severity | Location | Status |
|---|---|---|---|---|
| brace-expansion 1.1.16, 2.1.2, 5.0.7 | CVE-2026-14257 | HIGH | app/node_modules (Jest/test-exclude internals) | Accepted risk |

**Why accepted:** `brace-expansion` appears at three nested paths inside Jest's own dependency tree (`test-exclude`, `glob`, root). The fixed version is 5.0.8 but these are Jest's internal transitive dependencies — updating them independently would require Jest itself to release a patch. This package is only invoked by Jest at test time. No HTTP endpoint in the running application calls any function from brace-expansion. The container runs as non-root and has no test runner executing at runtime. Listed in `.trivyignore` with this reasoning.

## Scan 3: IaC Misconfiguration (Checkov)

**Result: PASSING (with documented skip list)**

Checkov scans the `terraform/azure/` directory against Azure provider rules. The scan is configured with `soft_fail: false` — it will fail the pipeline on any check not explicitly skipped. All skipped checks are documented below with specific reasoning. Full scan results are uploaded as `checkov-results` artifact on every CI run.

### Checks passing (25 total)

Key security checks that pass confirm the infrastructure is correctly secured:

| Check | What it validates | Result |
|---|---|---|
| CKV_AZURE_149 | VMs do not use password authentication (SSH keys only) | Passing |
| CKV_AZURE_178 | Linux VMs use SSH keys for secure communication | Passing |
| CKV_AZURE_179 | VM agent is installed | Passing |
| CKV_AZURE_92 | VMs use managed disks | Passing |
| CKV_AZURE_118 | Network interfaces disable IP forwarding | Passing |
| CKV_AZURE_119 | Compute VM (app) has no public IP | Passing |
| CKV_AZURE_137 | ACR admin account is disabled | Passing |
| CKV_AZURE_138 | ACR disables anonymous image pulling | Passing |
| CKV_AZURE_163 | ACR vulnerability scanning enabled | Passing |
| CKV2_AZURE_57 | PostgreSQL configured with private endpoint | Passing |
| CKV2_AZURE_31 | Both subnets have NSGs attached | Passing |
| CKV_AZURE_77 | UDP services restricted from internet | Passing |
| CKV_AZURE_182 | VNet has at least 2 DNS endpoints | Passing |

### Checks skipped — with justification

**Category 1: Architectural requirements (cannot be changed without breaking the system)**

| Check | Finding | Why skipped |
|---|---|---|
| CKV_AZURE_119 | Bastion NIC has a public IP | The Bastion host is the jump server that GitHub Actions SSHs into to reach the private application VM. Removing its public IP would make the entire CD deployment pipeline unreachable. This is correct architecture — the Bastion's purpose is to be the single public entry point. |
| CKV_AZURE_160 | HTTP port 80 open from internet on public NSG | The application must be accessible to users on port 80. Restricting port 80 from the internet defeats the purpose of a web application. Traffic is controlled through the public/private subnet separation. |
| CKV_AZURE_139 | ACR public networking not disabled | GitHub Actions runners are GitHub-hosted and do not have fixed IPs. The CD pipeline must push images to ACR from the internet. Disabling public networking would require VNet-integrated self-hosted runners which is beyond student project scope. Mitigated by ACR admin being disabled (CKV_AZURE_137 passes) and anonymous pulls disabled (CKV_AZURE_138 passes). |

**Category 2: False positive**

| Check | Finding | Why skipped |
|---|---|---|
| CKV_AZURE_50 | "VM Extensions not installed" fails on both VMs | No VM extensions are defined anywhere in the Terraform code. Checkov flags any `azurerm_linux_virtual_machine` resource as a precautionary check regardless of whether extensions exist. This is a false positive. |

**Category 3: Premium SKU features — not appropriate for student project**

| Check | Feature required | Approximate monthly cost | Why skipped |
|---|---|---|---|
| CKV_AZURE_136 | PostgreSQL geo-redundant backups | ~$100+/month extra | 7-day backup retention is already configured. Geo-redundancy is for production disaster recovery at scale. |
| CKV_AZURE_165 | ACR geo-replication | Requires Premium ACR (~$200+/month) | Single region is sufficient for this project scope. |
| CKV_AZURE_233 | ACR zone redundancy | Requires Premium ACR | Single availability zone is acceptable for student project. |
| CKV_AZURE_237 | ACR dedicated data endpoints | Requires Premium ACR | Standard endpoints are sufficient. |
| CKV_AZURE_164 | ACR content trust (signed images) | Requires Premium ACR + key infrastructure | Image integrity is enforced by Trivy scanning before push instead. |
| CKV_AZURE_166 | ACR image quarantine policy | Requires Microsoft Defender for Containers | Equivalent protection provided by Trivy scanning in CI. |
| CKV_AZURE_167 | ACR retention policy for untagged manifests | Requires Premium ACR | Images are tagged with commit SHA — untagged manifests are not expected. |

## Remediation Summary

| Action | Tool | Outcome |
|---|---|---|
| `apt-get upgrade` added to Dockerfile production stage | Trivy | Eliminated 6 OS-level CVEs |
| npm CLI removed from production image | Trivy | Eliminated 12 npm-internal CVE findings |
| `ignore-unfixed: true` in Trivy config | Trivy | Reports only actionable findings |
| `--omit=dev` flag on npm audit | npm audit | Scopes audit to production dependencies only |
| Checkov skip list with documented justification | Checkov | 12 checks skipped transparently with reasoning |
| `soft_fail: false` on Checkov | Checkov | Any unskipped check failure blocks the merge |
| Non-root user (`USER node`) in Dockerfile | All | Limits blast radius if container is compromised |
| ACR admin account disabled | Checkov/ACR | No single credential can access the registry |
| ACR anonymous pull disabled | Checkov/ACR | Images cannot be pulled without authentication |
| PostgreSQL in private subnet with private endpoint | Checkov/Network | Database unreachable from internet |
| App VM in private subnet with no public IP | Checkov/Network | Application server unreachable directly from internet |
| SSH key-only authentication on all VMs | Checkov/SSH | No password brute-force attack surface |
| `.env` gitignored, `.env.example` committed | All | No secrets in version control |

## Accepted Risks Register

| Risk | Severity | Reason Accepted | Mitigation |
|---|---|---|---|
| brace-expansion CVE-2026-14257 in Jest devDependency | HIGH | Jest internal dependency — not reachable at runtime | Not executed in production container; container runs as non-root |
| Bastion host has public IP (CKV_AZURE_119) | Design trade-off | Required for CD pipeline SSH access | Bastion is only VM with public IP; app VM has no public IP; SSH key authentication only |
| HTTP port 80 open from internet (CKV_AZURE_160) | Design trade-off | Web application must be accessible to users | Traffic restricted to ports 80/443 only; database in private subnet |
| ACR public networking enabled (CKV_AZURE_139) | Design trade-off | GitHub Actions runners need internet access to push | Admin account disabled; anonymous pull disabled; images scanned before push |
| ACR Premium features not enabled | Low risk | Cost prohibitive for student project | Trivy scanning in CI provides equivalent image security coverage |

## Reporting a Vulnerability

If you discover a security vulnerability in MedStock Monitor, do not open a public GitHub issue. Use GitHub's private vulnerability reporting feature on the Security tab of the repository, or contact the repository owner directly.