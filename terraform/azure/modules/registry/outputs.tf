output "acr_login_server" {
  description = "Login server for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  description = "Resource ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_resource_group" {
  description = "Resource group containing the ACR"
  value       = azurerm_container_registry.acr.resource_group_name
}
