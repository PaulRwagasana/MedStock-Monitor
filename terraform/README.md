# 🌐 Terraform — MedStock Monitor Infrastructure

> **Provisions the Docker networking and container infrastructure for the MedStock Monitor application.**

---

## Overview

This directory contains the Terraform configuration for the MedStock Monitor infrastructure. It uses the Docker provider to provision a dedicated network, a PostgreSQL database container, and the backend application container — all managed as code.

---

## What It Provisions

| Resource | Name | Description |
|----------|------|-------------|
| Docker Network | `medstock-network` | Isolated bridge network shared by all services |
| Postgres Container | `medstock-db` | PostgreSQL 15 database with a persistent volume |
| Backend Container | `medstock-backend` | MedStock Monitor application pulled from GHCR |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [Docker](https://docs.docker.com/get-docker/) running locally

---

## How to Run

### 1. Change into this directory

```bash
cd terraform
```

### 2. Copy the example variables file

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in your values. Never commit `terraform.tfvars` — it is listed in `.gitignore`.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the plan

```bash
terraform plan -var-file="terraform.tfvars"
```

### 5. Apply

```bash
terraform apply -var-file="terraform.tfvars"
```

Type `yes` when prompted. Key infrastructure details will be printed as outputs on completion.

### 6. Verify containers are running

```bash
docker ps
docker network ls
```

### 7. Destroy when done

```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `network_name` | Name of the Docker bridge network | `medstock-network` |
| `backend_container_name` | Name of the backend container | `medstock-backend` |
| `postgres_container_name` | Name of the PostgreSQL container | `medstock-db` |
| `backend_image` | Backend image pulled from GHCR | `ghcr.io/cletusaabugre/medstock-monitor:ci` |
| `backend_internal_port` | Port the app listens on inside the container | `5000` |
| `backend_external_port` | Port exposed on the host | `5000` |
| `postgres_port` | PostgreSQL port | `5432` |
| `db_name` | PostgreSQL database name | `medstock` |
| `db_user` | PostgreSQL username | `postgres` |
| `db_password` | PostgreSQL password (sensitive) | `postgres` |

> **Note:** Change `db_password` from the default before any real deployment.

---

## Outputs

| Output | Description |
|--------|-------------|
| `docker_network_name` | Name of the Docker network |
| `docker_network_id` | ID of the Docker network |
| `backend_container_name` | Name of the backend container |
| `backend_container_id` | ID of the backend container |
| `backend_url` | URL to reach the app from the host |
| `postgres_container_name` | Name of the Postgres container |
| `postgres_container_id` | ID of the Postgres container |

---

## File Structure

```text
terraform/
├── main.tf                   # Docker network and Postgres container
├── compute.tf                # Backend application container
├── versions.tf               # Terraform and Docker provider version constraints
├── variables.tf              # Input variable declarations
├── outputs.tf                # Output value declarations
├── terraform.tfvars.example  # Example variable values (safe to commit)
└── README.md                 # This file
```

---

## Security Notes

- Never commit `terraform.tfvars` — it is gitignored
- Change `db_password` from the default value before any real deployment
- The backend container only exposes port 5000 — the database port is not published to the host
