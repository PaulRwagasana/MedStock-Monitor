output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}

output "bastion_public_ip_id" {
  description = "Public IP resource id"
  value       = azurerm_public_ip.bastion_pip.id
}

output "bastion_nic_id" {
  description = "Network interface id for bastion"
  value       = azurerm_network_interface.bastion_nic.id
}

output "bastion_vm_id" {
  description = "Virtual machine resource id for bastion"
  value       = azurerm_linux_virtual_machine.bastion_vm.id
}

output "bastion_ssh_user" {
  description = "Admin SSH username"
  value       = var.admin_username
}
