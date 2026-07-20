output "resource_group_name" {
  description = "The resource group created for the MedStock infrastructure."
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  description = "The ID of the created virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_name" {
  description = "The name of the application subnet."
  value       = azurerm_subnet.app_subnet.name
}

output "subnet_id" {
  description = "The ID of the application subnet."
  value       = azurerm_subnet.app_subnet.id
}

output "network_security_group_id" {
  description = "The ID of the network security group attached to the subnet."
  value       = azurerm_network_security_group.nsg.id
}

output "public_ip_address" {
  description = "The public IP address assigned to the network interface."
  value       = azurerm_public_ip.public_ip.ip_address
}

output "network_interface_id" {
  description = "The ID of the network interface."
  value       = azurerm_network_interface.nic.id
}
