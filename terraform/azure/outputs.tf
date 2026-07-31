output "vnet_id" {
  description = "Virtual network ID"
  value       = module.network.vnet_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.network.private_subnet_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host (GitHub Secret: BASTION_HOST)."
  value       = module.bastion.bastion_public_ip
}

output "vm_private_ip" {
  description = "Private IP of the compute VM (GitHub Secret: VM_HOST)."
  value       = module.compute.vm_private_ip
}

output "db_fqdn" {
  description = "Database FQDN (GitHub Secret: DB_HOST)."
  value       = module.db.db_fqdn
}

output "acr_login_server" {
  description = "ACR login server (GitHub Secret: ACR_LOGIN_SERVER)."
  value       = module.registry.acr_login_server
}

# ---------------------------------------------------------------------------
# CI/CD and GitHub Secrets — surface existing module values (no new infra)
# ---------------------------------------------------------------------------

output "resource_group_name" {
  description = "Azure resource group name used by this deployment."
  value       = var.resource_group_name
}

output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = module.registry.acr_id
}

output "db_id" {
  description = "Resource ID of the PostgreSQL Flexible Server."
  value       = module.db.db_id
}

output "db_username" {
  description = "PostgreSQL administrator username (GitHub Secret: DB_USER)."
  value       = module.db.db_username
  sensitive   = true
}

output "db_port" {
  description = "PostgreSQL port (GitHub Secret: DB_PORT)."
  value       = 5432
}

output "bastion_ssh_user" {
  description = "SSH username for the bastion host (GitHub Secret: BASTION_USER)."
  value       = module.bastion.bastion_ssh_user
}

output "vm_id" {
  description = "Resource ID of the private application VM."
  value       = module.compute.vm_id
}

output "vm_identity_principal_id" {
  description = "Principal ID of the application VM system-assigned managed identity (AcrPull is assigned in the registry module)."
  value       = module.compute.identity_principal_id
}

output "ci_principal_id" {
  description = "CI/CD service principal object ID used for IAM role assignments."
  value       = module.iam.ci_principal_id
}

output "ci_acr_push_role_assignment_id" {
  description = "Role assignment ID for CI/CD AcrPush on ACR (null when not created)."
  value       = module.iam.ci_acr_push_role_assignment_id
}

output "ci_rg_reader_role_assignment_id" {
  description = "Role assignment ID for CI/CD Reader on the resource group (null when not created)."
  value       = module.iam.ci_rg_reader_role_assignment_id
}
