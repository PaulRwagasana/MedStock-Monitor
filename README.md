# 🌐 Terraform — MedStock Monitor Infrastructure

> **Provisions the Azure infrastructure for the MedStock Monitor application.**

---

## Overview

This directory contains the Terraform configuration for the MedStock Monitor infrastructure. It deploys an Azure networking foundation with a public bastion host, a private application VM, a PostgreSQL flexible server, and a private Azure Container Registry.

---

## What It Provisions

| Resource | Description |
|----------|-------------|
| Resource Group | Central Azure resource group for the deployment |
| Virtual Network + Subnets | Public subnet for the bastion host and private subnet for the app VM |
| NSGs | Network security rules for SSH and application traffic |
| Bastion VM | Public jump box used for secure administration |
| App VM | Private application host with a public IP for access |
| PostgreSQL Flexible Server | Managed database for the application |
| Azure Container Registry | Private registry for production container images |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- An Azure subscription
- Azure CLI authenticated with `az login`

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

### 6. Verify the deployment

```bash
terraform output
```

### 7. Destroy when done

```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Azure resource group name | `rg-medstock-monitor` |
| `location` | Azure region | `eastus` |
| `vnet_name` | Virtual network name | `medstock-vnet` |
| `public_subnet_cidr` | CIDR for the bastion subnet | `10.10.1.0/24` |
| `private_subnet_cidr` | CIDR for the app subnet | `10.10.2.0/24` |
| `bastion_vm_name` | Bastion host VM name | `medstock-bastion` |
| `app_vm_name` | Application VM name | `medstock-app` |
| `admin_username` | Admin username for both VMs | `azureuser` |
| `db_name` | PostgreSQL database name | `medstock` |
| `db_user` | PostgreSQL username | `postgres` |
| `db_password` | PostgreSQL password (sensitive) | `changeme` |
| `acr_name` | Azure Container Registry name | `medstockacr` |
| `acr_sku` | ACR SKU | `Basic` |

> **Note:** Change `db_password` from the default before any real deployment.

---

## Outputs

| Output | Description |
|--------|-------------|
| `resource_group_name` | Name of the Azure resource group |
| `bastion_public_ip` | Public IP of the bastion host |
| `app_vm_name` | Name of the application VM |
| `app_public_ip` | Public IP of the application VM |
| `app_url` | URL to reach the app from the public IP |
| `postgres_server_name` | Name of the PostgreSQL flexible server |
| `postgres_fqdn` | Fully qualified domain name of the database |
| `acr_name` | Name of the Azure Container Registry |
| `acr_login_server` | Login server for the container registry |

---

## File Structure

```text
terraform/
├── main.tf                   # Core Azure networking, VMs, NSGs, and registry resources
├── compute.tf                # Placeholder for deployment-related compute logic
├── versions.tf               # Terraform provider version constraints
├── variables.tf              # Input variable declarations
├── outputs.tf                # Output value declarations
├── terraform.tfvars.example  # Example variable values (safe to commit)
└── README.md                 # This file
```

---

## Security Notes

- Never commit `terraform.tfvars` — it is gitignored
- Change `db_password` and `admin_password` before any real deployment
- The application VM is exposed on port 5000, while the database remains managed privately
