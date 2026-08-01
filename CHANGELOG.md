# Changelog

All notable changes to MedStock Monitor are documented here, organised by project phase.

---

## [Summative] — 2026-07-31 — The Complete DevOps Pipeline

### Added
- `/health` endpoint (`GET /health`) — returns `{ status, db }` and checks live database connectivity; returns HTTP 503 if the database is unreachable
- Azure Terraform modules: `network` (VNet, subnets, NSGs), `bastion` (Bastion Host), `compute` (private VM, NIC, managed identity), `db` (managed PostgreSQL), `registry` (Azure Container Registry)
- Root `terraform/azure/` configuration wiring all modules together
- Ansible playbook (`ansible/site.yml`) — installs Docker, hardens SSH, configures UFW firewall, deploys Postgres and app containers via GHCR, waits for readiness on `/health`
- `ansible/group_vars/all.yml` — centralised variables for app, database, network, and firewall configuration
- `ansible/requirements.yml` — community.docker and community.general collections
- `ansible/ansible.cfg` — inventory path and SSH pipelining settings
- CD pipeline (`cd.yml`) — triggers on merge to `main`; builds and pushes image to ACR, runs Ansible playbook to deploy to VM

### Changed
- Dockerfile `HEALTHCHECK` updated to target `/health` instead of `/`
- Ansible readiness probe updated to poll `/health`
- CI pipeline extended: Checkov IaC scan scoped to Docker/Terraform provider, `.checkov.yaml` suppresses inapplicable Azure checks
- `README.md` updated with architecture diagram, live application URL, and full operations manual

---

## [Formative 3] — 2026-07-19 to 2026-07-23 — IaC & DevSecOps

### Added
- Terraform configuration using the Docker provider (`kreuzwerker/docker ~> 3.0`) — provisions Docker network, PostgreSQL container, and backend container
- `terraform/variables.tf` — shared variables for network, container names, ports, and database credentials
- `terraform/outputs.tf` — exposes network name, container names/IDs, and backend URL
- `terraform/versions.tf` — pins Terraform `>= 1.5.0` and Docker provider version
- `terraform/terraform.tfvars.example` — safe example values for all variables
- `terraform/README.md` — usage guide, variables reference, and outputs reference
- Checkov IaC scan job added to CI pipeline (`iac-scan` job in `ci.yml`)
- `.checkov.yaml` — scopes Checkov to Terraform/Docker, skips inapplicable Azure checks
- `.trivyignore` — documents and suppresses accepted CVEs with justification
- `SECURITY.md` — documents all known findings, remediation status, and accepted risks
- Ansible `inventory.ini`, `ansible.cfg`, `requirements.yml`, and `group_vars/all.yml`

### Changed
- Dockerfile hardened: OS packages upgraded at build time, bundled `npm` CLI removed from production image to resolve `tar`/`brace-expansion` CVEs
- `npm audit` scoped to production dependencies only (`--omit=dev`) in CI
- Trivy scan configured with `exit-code: 1` on CRITICAL/HIGH — pipeline fails on unresolved vulnerabilities
- `brace-expansion` dependency updated to resolve HIGH vulnerability found by `npm audit`

### Fixed
- Hardcoded database password removed from Terraform configuration

---

## [Formative 2] — 2026-07-03 to 2026-07-04 — Containerization & CI Pipeline

### Added
- `Dockerfile` — multi-stage build (builder + production), non-root `node` user, `HEALTHCHECK`, `EXPOSE 5000`
- `docker-compose.yml` — orchestrates `backend` and `postgres:15` services with health check, named network, and persistent volume
- `.dockerignore` — excludes `node_modules`, test files, and local config from image
- `.env.example` — documents all required environment variables
- CI pipeline (`.github/workflows/ci.yml`) — runs on push and PRs to `main`
  - Lint job: ESLint across Node 20 and 22 matrix
  - Test job: Jest with coverage report uploaded as artifact
  - Security job: `npm audit --audit-level=high`
  - Docker build job: builds image, scans with Trivy, pushes to GHCR on push events
- `CODEOWNERS` — enforces code review assignments per directory
- MIT `LICENSE`

### Changed
- Data storage migrated from local JSON file (`data/medicines.json`) to PostgreSQL
- `backend/src/config/db.js` — replaced JSON reads with `pg` connection pool
- All medicine model queries rewritten as parameterised SQL
- `docker-compose.yml` uses `.env` file for database credentials instead of hardcoded values
- `npm install` replaced with `npm ci` in Dockerfile for reproducible builds
- Node.js version standardised to 20 across Dockerfile and CI matrix

---

## [Formative 1] — 2026-06-25 to 2026-06-28 — Project Foundation

### Added
- Repository initialised with branch protection on `main` (PR required, review required)
- `CODEOWNERS` file for ownership assignments
- Express backend (`backend/`) with full REST API:
  - `GET /api/medicines` — list all medicines
  - `GET /api/medicines/search?name=` — search by name
  - `GET /api/medicines/alerts/low-stock` — medicines below threshold
  - `GET /api/medicines/category/:category` — filter by category
  - `GET /api/medicines/:id` — single medicine
  - `POST /api/medicines` — add medicine
  - `PUT /api/medicines/:id` — update medicine
  - `DELETE /api/medicines/:id` — delete medicine
  - `PATCH /api/medicines/:id/add-stock` — increase stock
  - `PATCH /api/medicines/:id/reduce-stock` — decrease stock
- Frontend (`frontend/`) — HTML/CSS/JS dashboard with purple-themed UI, search bar, stock adjustment, low-stock view
- `backend/migrations/001_create_tables.sql` — schema and seed data (8 medicines across 5 categories)
- `data/medicines.json` — prototype JSON data store
- `backend/src/__tests__/Medicine.test.js` — unit tests for medicine model
- `backend/eslint.config.js` — ESLint configuration
- `README.md` — full project description, setup instructions, API reference, team info
- GitHub Projects board (Kanban) for task tracking
- `.gitignore` covering `node_modules`, `.env`, coverage reports
