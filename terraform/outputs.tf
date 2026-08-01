output "resource_group_name" {
  description = "The Azure resource group for the deployment."
  value       = azurerm_resource_group.rg.name
}

output "bastion_public_ip" {
  description = "The public IP of the bastion host."
  value       = azurerm_public_ip.bastion_ip.ip_address
}

output "app_vm_name" {
  description = "The name of the application VM."
  value       = azurerm_linux_virtual_machine.app.name
}

output "postgres_server_name" {
  description = "The PostgreSQL flexible server name."
  value       = azurerm_postgresql_flexible_server.db.name
}

output "postgres_fqdn" {
  description = "The PostgreSQL server FQDN."
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "app_url" {
  description = "The application endpoint exposed through the public IP."
  value       = format("http://%s:5000", azurerm_public_ip.app_ip.ip_address)
}

output "acr_name" {
  description = "The Azure Container Registry name."
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "The Azure Container Registry login server."
  value       = azurerm_container_registry.acr.login_server
}