Azure Terraform layout for MedStock-Monitor

This directory contains guidance and a recommended module layout for provisioning the Summative project infrastructure on Microsoft Azure.

Goal
- Provide a modular Terraform layout that provisions a private network, a bastion host, a private VM in a private subnet, a managed PostgreSQL database, and an Azure Container Registry (ACR).

Prerequisites
- An Azure subscription and an Azure CLI login (`az login`).
- Terraform 1.4+ installed locally.
- Create an Azure Resource Group for the environment or let Terraform create one.
- (Recommended) An Azure Storage Account + blob container to store remote state and enable locking.

Directory layout

- terraform/azure/
  - providers.tf        # azurerm provider configuration and required_providers
  - versions.tf         # Terraform required_version and provider versions
  - backend.tf          # optional: configure remote state (azurerm backend)
  - main.tf             # root module that calls submodules and wires variables
  - variables.tf        # high-level variables (environment, location, prefixes)
  - outputs.tf          # environment outputs (bastion_ip, vm_private_ip, acr_login_server)
  - terraform.tfvars.example
  - modules/
    - network/          # VNet, public/private subnets, network security groups (NSGs)
    - bastion/          # Public VM (small) + public IP + NSG for SSH (limit by IP)
    - compute/          # Private VM, NIC, private IP, VM scale set optional
    - db/               # Azure Database for PostgreSQL Flexible Server (private access)
    - registry/         # Azure Container Registry (ACR) + RA assignments
    - iam/              # CI/CD service principal role assignments (AcrPush, RG Reader)
  - examples/
    - simple.tfvars     # example var values for quick testing
  - README.md           # (this file)

Module responsibilities (recommended)
- network:
  - Create a VNet with at least two subnets: public (for bastion) and private (for app VMs).
  - Create NSGs for subnet or NIC-level rules: allow inbound SSH to bastion from a restricted IP, allow HTTP/HTTPS to load balancer or NAT as needed.
  - (Optional) Private DNS zones and private endpoints for DB and ACR.

- bastion:
  - Provision a small Linux VM in the public subnet with a public IP.
  - Harden NSG rules: only allow SSH from your IP or GitHub Actions runner ranges if needed.
  - Provide an output with the bastion public IP.

- compute:
  - Provision the application VM(s) in the private subnet. No public IP.
  - Attach a system-assigned managed identity to the VM to grant `acrPull` role on ACR.
  - Install a NIC and optional boot diagnostics storage.

- db:
  - Create Azure Database for PostgreSQL Flexible Server with VNet integration or private endpoint.
  - Ensure the server is placed in the private subnet or accessible via private endpoint.
  - Use sensitive variables for DB admin password and rotate credentials securely.

- registry:
  - Create an Azure Container Registry (sku = Standard or Premium for geo-replication if required).
  - Disable the admin user. Use a service principal or managed identity for authentication.
  - Optionally create an offline replication or retention policy per assignment requirements.
  - Assigns `AcrPull` to the application VM managed identity (owned by the registry module).

- iam:
  - Does **not** create VMs, ACR, PostgreSQL, networking, or bastion resources.
  - Assigns least-privilege Azure RBAC to the CI/CD service principal against existing resources:
    - `AcrPush` on the existing ACR (`module.registry.acr_id`)
    - optional `Reader` on the existing resource group
  - Controlled by root variables `ci_principal_id`, `enable_ci_acr_push`, and `enable_ci_rg_reader`.

Security & Access
- Use managed identities for the VM to authenticate to ACR (preferred) and avoid storing credentials on the VM.
- Use private endpoints for both ACR and PostgreSQL to keep traffic inside the VNet.
- Use Azure Key Vault to store secrets (DB password) and reference them in your Ansible playbook or VM provisioning.
- Harden NSGs: allow only necessary inbound ports, and limit SSH to known IP addresses.
- Use a dedicated CI/CD service principal with `AcrPush` (via `modules/iam`) instead of enabling the ACR admin user.

Remote State
- Store Terraform state in an Azure Storage Account with blob container and enable `resource_lock` if possible.
- Example backend block (backend.tf):

  terraform {
    backend "azurerm" {
      resource_group_name  = "rg-terraform-state"
      storage_account_name = "tfstate<unique>"
      container_name       = "tfstate"
      key                  = "medstock.tfstate"
    }
  }

Authentication for CI/CD
- Create a CI/CD service principal with least privilege (prefer `AcrPush` + `Reader`, not broad Contributor):

```bash
az ad sp create-for-rbac \
  --name "medstock-github-ci" \
  --role Reader \
  --scopes "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>" \
  --sdk-auth
```

- Store the JSON output as the GitHub Secret `AZURE_CREDENTIALS` (used by `azure/login`).
- Copy the service principal **object id** into Terraform:

```bash
az ad sp show --id <APP_ID> --query id -o tsv   # -> ci_principal_id
```

- Set `ci_principal_id` in `terraform.tfvars` so `modules/iam` can grant `AcrPush` on ACR (and optional RG `Reader` if not already granted by `create-for-rbac`).
- After `terraform apply`, map outputs to GitHub Secrets (see table below). Use `az acr login` / Azure login in workflows — keep ACR admin disabled.

## GitHub Secrets mapping

| GitHub Secret | Source | How to obtain |
|---------------|--------|---------------|
| `AZURE_CREDENTIALS` | CI/CD service principal | JSON from `az ad sp create-for-rbac --sdk-auth` (not a Terraform output) |
| `ACR_LOGIN_SERVER` | Terraform output `acr_login_server` | `terraform output -raw acr_login_server` |
| `DB_HOST` | Terraform output `db_fqdn` | `terraform output -raw db_fqdn` |
| `DB_USER` | Terraform output `db_username` | `terraform output -raw db_username` |
| `DB_PORT` | Terraform output `db_port` | `terraform output -raw db_port` (always `5432`) |
| `DB_PASSWORD` | Same value as `db_administrator_password` | From your secret store / `terraform.tfvars` (do not commit) |
| `DB_NAME` | Application convention | Usually `medstock` (confirm with DB module / app config) |
| `BASTION_HOST` | Terraform output `bastion_public_ip` | `terraform output -raw bastion_public_ip` |
| `BASTION_USER` | Terraform output `bastion_ssh_user` | `terraform output -raw bastion_ssh_user` |
| `VM_HOST` | Terraform output `vm_private_ip` | `terraform output -raw vm_private_ip` |
| `SSH_PRIVATE_KEY` | Key pair matching `admin_ssh_public_key` | Generated locally / in your secret store (not Terraform) |

Related IAM outputs (for verification, not always stored as secrets):
- `ci_principal_id`
- `ci_acr_push_role_assignment_id`
- `ci_rg_reader_role_assignment_id`
- `vm_identity_principal_id` (VM managed identity used for `AcrPull`)
- `acr_id`, `db_id`, `resource_group_name`

Terraform workflow (local testing)

1. Login with Azure CLI:

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

2. Initialize and plan:

```bash
cd terraform/azure
terraform init
terraform plan -var-file=terraform.tfvars
```

3. Apply (review plan first):

```bash
terraform apply -var-file=terraform.tfvars
```

Authentication note
- This repo supports both Azure CLI auth and explicit service principal auth.
- For Azure CLI auth, run `az login` before Terraform and leave the SP vars unset.
- For explicit service principal auth, set these values in `terraform.tfvars` or pass them as `-var`:

```hcl
client_id       = "<YOUR-SP-CLIENT-ID>"
client_secret   = "<YOUR-SP-CLIENT-SECRET>"
tenant_id       = "<YOUR-TENANT-ID>"
subscription_id = "<YOUR-SUBSCRIPTION-ID>"
```

Ansible integration (high-level)
- Keep Ansible playbooks in the repo's `ansible/` directory.
- Use Terraform outputs to generate an inventory (`bastion_public_ip`, `bastion_ssh_user`, `vm_private_ip`, and your SSH private key).
- The CD workflow should: authenticate with `AZURE_CREDENTIALS` -> build image -> push to ACR (`AcrPush` via IAM) -> run Ansible against the private VM via the bastion (VM pulls with managed identity `AcrPull`).
