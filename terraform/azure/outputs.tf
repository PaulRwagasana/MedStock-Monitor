output "resource_group_name" {
  description = "Name of the managed resource group"
  value       = azurerm_resource_group.rg.name
}

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
  description = "Public IP of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "vm_private_ip" {
  description = "Private IP of the compute VM"
  value       = module.compute.vm_private_ip
}

output "db_fqdn" {
  description = "Database FQDN"
  value       = module.db.db_fqdn
}

output "acr_login_server" {
  description = "ACR login server"
  value       = module.registry.acr_login_server
}