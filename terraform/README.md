# 🌐 Terraform — MedStock Monitor Networking

This folder contains a Docker-based Terraform configuration for the networking layer of the MedStock Monitor project.

---

- A Docker network shared by the application services
- A PostgreSQL container for the database
- A backend container for the application
- Port mappings so the services are reachable from the host machine
- Outputs for the main container and network values

## Prerequisites

- Terraform >= 1.5
- Docker Engine or Docker Desktop running locally

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

   ```bash
   terraform plan
   ```

```text
terraform/
├── main.tf                   # All Azure resource definitions
├── versions.tf               # Terraform and provider version constraints
├── variables.tf              # Input variable declarations
├── outputs.tf                # Output value declarations
├── terraform.tfvars.example  # Example variable values (safe to commit)
└── README.md                 # This file
```

   ```bash
   terraform apply
   ```

5. Check the running containers:

   ```bash
   docker ps
   docker network ls
   ```

## Security Notes

- The default database credentials are simple example values and should be changed for a real deployment.
- The backend image is expected to be available locally or buildable through Docker before applying the configuration.
