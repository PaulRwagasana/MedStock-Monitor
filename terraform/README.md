# 🌐 Terraform — MedStock Monitor Networking

> **Provisions the Azure networking infrastructure for the MedStock Monitor application.**

---

## Overview

This directory contains the Terraform configuration for the MedStock Monitor networking layer on Azure. It sets up the virtual network, subnet, security rules, public IP, and network interface needed to host the application.

---

## What It Provisions

| Resource | Name | Description |
|----------|------|-------------|
| Resource Group | `rg-medstock-dev` | Container for all Azure resources |
| Virtual Network | `vnet-medstock-dev` | Isolated network (`10.10.0.0/16`) |
| Subnet | `snet-app` | Application subnet (`10.10.1.0/24`) |
| Network Security Group | `nsg-medstock-dev` | Firewall rules for inbound traffic |
| NSG Rules | allow-ssh, allow-http, allow-https, allow-app | Opens ports 22, 80, 443, 5000 |
| Public IP | `pip-medstock-dev` | Static public IP for the server |
| Network Interface | `nic-medstock-dev` | Connects the VM to the subnet and public IP |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- An active Azure account
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and signed in

Sign in before running any commands:

```bash
az login
```

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

### 6. Destroy when done

```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Name of the Azure resource group | `rg-medstock-dev` |
| `location` | Azure region for all resources | `eastus` |
| `environment` | Deployment environment tag | `dev` |
| `vnet_name` | Name of the virtual network | `vnet-medstock-dev` |
| `vnet_address_space` | Address space for the VNet | `["10.10.0.0/16"]` |
| `subnet_name` | Name of the application subnet | `snet-app` |
| `subnet_address_prefixes` | CIDR block for the subnet | `["10.10.1.0/24"]` |
| `nsg_name` | Name of the network security group | `nsg-medstock-dev` |
| `public_ip_name` | Name of the public IP resource | `pip-medstock-dev` |
| `nic_name` | Name of the network interface | `nic-medstock-dev` |
| `allowed_source_ip` | CIDR allowed inbound access | `0.0.0.0/0` |
| `app_port` | Port used by the application backend | `5000` |
| `tags` | Tags applied to all resources | see `variables.tf` |

> **Note:** `allowed_source_ip` defaults to `0.0.0.0/0` for development. Restrict this to your own IP range before any production deployment.

---

## Outputs

| Output | Description |
|--------|-------------|
| `resource_group_name` | Name of the provisioned resource group |
| `virtual_network_name` | Name of the virtual network |
| `virtual_network_id` | Resource ID of the virtual network |
| `subnet_name` | Name of the application subnet |
| `subnet_id` | Resource ID of the application subnet |
| `network_security_group_id` | Resource ID of the NSG |
| `public_ip_address` | The public IP address assigned to the NIC |
| `network_interface_id` | Resource ID of the network interface |

---

## File Structure

```text
terraform/
├── main.tf                   # All Azure resource definitions
├── versions.tf               # Terraform and provider version constraints
├── variables.tf              # Input variable declarations
├── outputs.tf                # Output value declarations
├── terraform.tfvars.example  # Example variable values (safe to commit)
└── README.md                 # This file
```

---

## Security Notes

- Never commit `terraform.tfvars` — it is gitignored
- All resources are tagged with `managedBy = "terraform"` for traceability
- Restrict `allowed_source_ip` to a known IP range before any production deployment
