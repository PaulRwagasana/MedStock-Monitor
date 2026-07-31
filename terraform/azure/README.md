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
    - iam/              # Managed identities or service principal role assignments
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

Security & Access
- Use managed identities for the VM to authenticate to ACR (preferred) and avoid storing credentials on the VM.
- Use private endpoints for both ACR and PostgreSQL to keep traffic inside the VNet.
- Use Azure Key Vault to store secrets (DB password) and reference them in your Ansible playbook or VM provisioning.
- Harden NSGs: allow only necessary inbound ports, and limit SSH to known IP addresses.

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
- For GitHub Actions CD workflow, create an Azure service principal with least privilege (contributor to target RG or specific resources), and store `AZURE_CREDENTIALS` in GitHub Secrets (JSON output from `az ad sp create-for-rbac`), or use the `azure/login` action.
- For ACR push/pull: configure `AZURE_ACR_LOGIN_SERVER`, and authenticate using `az acr login` or `docker login` with `az acr login` credentials in the workflow.

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

Ansible integration (high-level)
- Keep Ansible playbooks in the repo's `ansible/` directory.
- Use Terraform outputs to generate an inventory (public IP of bastion, private IP of VM, private key location).
- The CD workflow should: build image -> push to ACR -> run Ansible against the private VM via the bastion (or use GitHub Actions self-hosted runner in same VNet) to pull the image and restart the service.

Next steps I can help implement
- Scaffold the `.tf` module files for `network`, `bastion`, `compute`, `db`, and `registry` (I will not write final production-grade configs without your confirmation).
- Draft GitHub Actions `cd.yml` that authenticates to Azure, builds/pushes to ACR, and runs Ansible against the VM.

Notes on academic integrity
- You must author your Terraform and Ansible config files yourself per course rules; I'm providing a layout and guidance to help you implement them.

If you want, I can now scaffold starter `.tf` files under `terraform/azure/modules/` to accelerate development — tell me to proceed with scaffolding.