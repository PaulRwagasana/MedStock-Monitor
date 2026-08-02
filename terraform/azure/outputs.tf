output "bastion_public_ip" {
  description = "Bastion public IP — use as BASTION_HOST secret"
  value       = module.bastion.bastion_public_ip
}

output "vm_private_ip" {
  description = "App VM private IP — use as VM_PRIVATE_IP secret"
  value       = module.compute.vm_private_ip
}

output "acr_login_server" {
  description = "ACR login server — use as ACR_LOGIN_SERVER secret"
  value       = module.registry.acr_login_server
}

output "acr_name" {
  description = "ACR name — use as ACR_NAME secret"
  value       = "${var.name_prefix}acr"
}

output "db_host" {
  description = "PostgreSQL FQDN — use as DB_HOST secret"
  value       = module.db.db_fqdn
}

output "db_username" {
  description = "PostgreSQL admin username — use as DB_USER secret"
  value       = module.db.db_username
}

output "admin_username" {
  description = "VM admin username — use as VM_USER secret"
  value       = var.admin_username
}

output "app_url" {
  description = "Application URL via bastion"
  value       = "http://${module.bastion.bastion_public_ip}:5000"
}
