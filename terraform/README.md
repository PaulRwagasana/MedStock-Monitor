# Azure Terraform  MedStock Monitor

Modular Terraform configuration that provisions the production infrastructure for MedStock Monitor on Microsoft Azure: a private VNet, a bastion host, a private application VM, a managed PostgreSQL database, and an Azure Container Registry (ACR).

## Prerequisites

- An Azure subscription and `az login` access.
- Terraform >= 1.5.0.
- An Azure Resource Group (Terraform creates one, `resource_group_name` var).
- (Recommended) An Azure Storage Account + blob container for remote state.

## Directory layout

```
terraform/azure/
├── providers.tf         # azurerm provider configuration
├── main.tf              # root module: resource group, DB subnet, DNS zone, module wiring
├── variables.tf         # root-level variables
├── outputs.tf           # bastion_public_ip, vm_private_ip, acr_login_server, db_host, app_url, ...
├── modules/
│   ├── network/          # VNet, public/private subnets, NSGs
│   ├── bastion/           # Public VM + public IP + NSG (SSH + app port)
│   ├── compute/           # Private app VM, NIC, managed identity
│   ├── db/                # Azure Database for PostgreSQL Flexible Server (private endpoint)
│   └── registry/          # Azure Container Registry + ACR pull role assignment
└── README.md
```

## Module responsibilities

**network** : VNet with a public subnet (bastion) and a private subnet (app VM). The public subnet's NSG allows inbound SSH and the app port; the private subnet's NSG denies all inbound internet traffic. A separate delegated subnet in `main.tf` hosts the PostgreSQL Flexible Server.

**bastion** : Small VM in the public subnet with a static public IP. Its NSG allows SSH (from `allowed_ssh_cidrs`) and the app port (`app_port`, default `5000`). The Ansible playbook (`ansible/site.yml`, bastion play) installs `socat` on this VM as a systemd service that forwards the app port to the private app VM's internal IP — this is what makes the app reachable from the internet, since the app VM itself has no public IP.

**compute** : Private application VM, no public IP, reached only through the bastion. Has a system-assigned managed identity used to authenticate to ACR (`acrPull` role).

**db** : Azure Database for PostgreSQL Flexible Server, deployed into a delegated subnet with a private DNS zone. Not reachable from the public internet.

**registry** : Azure Container Registry. Admin account and anonymous pull are disabled; the app VM's managed identity is granted `acrPull`.

## Security notes

- The app VM and database have no public IP; the bastion is the single public entry point.
- SSH uses key-based auth only (`disable_password_authentication = true`); the bastion NSG restricts SSH to `allowed_ssh_cidrs`.
- ACR admin user is disabled — auth is via the compute VM's managed identity.
- Checkov scans this directory in CI (`terraform/azure`); skipped checks and the reasoning behind each are documented in [`SECURITY.md`](../../SECURITY.md).

## Remote state

Not currently configured : state is local. To add remote state, add a `backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate<unique>"
    container_name       = "tfstate"
    key                  = "medstock.tfstate"
  }
}
```

## Usage

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"

cd terraform/azure
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

For service-principal auth instead of `az login`, set in `terraform.tfvars` or via `-var`:

```hcl
client_id       = "<SP-CLIENT-ID>"
client_secret   = "<SP-CLIENT-SECRET>"
tenant_id       = "<TENANT-ID>"
subscription_id = "<SUBSCRIPTION-ID>"
```

## CI/CD authentication

The CD workflow (`.github/workflows/cd.yml`) authenticates to Azure with `azure/login` using an `AZURE_CREDENTIALS` secret (JSON from `az ad sp create-for-rbac`), and to ACR with `azure/docker-login` using `ACR_LOGIN_SERVER` / `ACR_USERNAME` / `ACR_PASSWORD`.

## Ansible integration

Terraform provisions the infrastructure; Ansible (`ansible/site.yml`) configures it. Two plays run against the inventory produced from Terraform's outputs (`bastion_public_ip`, `vm_private_ip`):

1. **medstock** (app VM): installs Docker, hardens SSH, deploys the app container.
2. **bastion**: installs and enables the `socat` forwarding service that exposes the app on the bastion's public IP.