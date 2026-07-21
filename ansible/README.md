# ⚙️ Ansible — MedStock Monitor Server Configuration

> **Configures the server provisioned by Terraform and deploys the MedStock Monitor application.**

---

## Overview

This directory contains the Ansible playbook that takes a freshly provisioned Azure VM and gets it ready — installing Docker, hardening security, and deploying the MedStock Monitor app and Postgres database as containers.

---

## What It Does

| Task | Description |
|------|-------------|
| Install dependencies | Installs Docker, UFW, fail2ban, and supporting packages |
| Configure Docker | Sets up the Docker daemon and adds the login user to the docker group |
| Harden security | Enables UFW with deny-by-default, disables SSH root login and password auth, starts fail2ban |
| Deploy Postgres | Runs the `postgres:15` container with a persistent volume on the app network |
| Deploy application | Pulls and runs the MedStock Monitor image from GHCR |
| Health check | Waits for the app to respond on port 5000 before finishing |

---

## Prerequisites

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) >= 2.14
- The target server provisioned and reachable over SSH
- SSH key access to the server
- Required Ansible collections installed (see below)

---

## Setup

### 1. Install required collections

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

### 2. Create your inventory file

Create `ansible/inventory.ini` — this file is gitignored, never commit it:

```ini
[medstock]
<your-server-public-ip> ansible_user=<ssh-user> ansible_ssh_private_key_file=~/.ssh/<your-key>
```

### 3. Set your secrets with Ansible Vault

The playbook uses two vaulted variables:

| Variable | Description |
|----------|-------------|
| `vault_db_password` | Password for the Postgres database |
| `vault_ghcr_token` | GitHub token for pulling from GHCR (only needed if the package is private) |

Create an encrypted vars file:

```bash
ansible-vault create ansible/group_vars/vault.yml
```

Add inside:

```yaml
vault_db_password: <your-db-password>
vault_ghcr_token: <your-github-token>
```

---

## How to Run

### Run the full playbook

```bash
ansible-playbook ansible/site.yml --ask-vault-pass
```

### Dry run (check mode)

```bash
ansible-playbook ansible/site.yml --check --ask-vault-pass
```

---

## Configuration

All non-secret variables are in `ansible/group_vars/all.yml`:

| Variable | Description | Default |
|----------|-------------|---------|
| `app_name` | Application container name | `medstock-monitor` |
| `db_container_name` | Postgres container name | `medstock-db` |
| `network_name` | Docker network name | `medstock-network` |
| `app_image` | Full GHCR image path | `ghcr.io/paulrwagasana/medstock-monitor:ci` |
| `app_port` | Host port the app is exposed on | `5000` |
| `container_port` | Port the app listens on inside the container | `5000` |
| `db_name` | Postgres database name | `medstock` |
| `db_user` | Postgres user | `postgres` |
| `allowed_ports` | Ports opened in UFW | `[22, 5000]` |
| `ghcr_package_is_private` | Whether GHCR login step runs | `false` |

---

## File Structure

```text
ansible/
├── site.yml              # Main playbook
├── ansible.cfg           # Ansible configuration (inventory path, SSH settings)
├── requirements.yml      # Required collections (community.docker, community.general)
├── group_vars/
│   └── all.yml           # Shared non-secret variables
└── README.md             # This file
```

---

## Notes

- The playbook is idempotent — safe to run multiple times
- Postgres readiness is checked before the app container starts
- `inventory.ini` and `group_vars/vault.yml` are gitignored — create them locally before running
