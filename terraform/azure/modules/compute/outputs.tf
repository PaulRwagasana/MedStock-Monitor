output "vm_private_ip" {
  description = "Private IP of the VM"
  value       = azurerm_network_interface.compute_nic.private_ip_address
}

output "vm_id" {
  description = "VM resource id"
  value       = azurerm_linux_virtual_machine.compute_vm.id
}

output "nic_id" {
  description = "Network interface id"
  value       = azurerm_network_interface.compute_nic.id
}

output "identity_principal_id" {
  description = "Principal ID for the system-assigned identity"
  value       = azurerm_linux_virtual_machine.compute_vm.identity[0].principal_id
}
