resource "azurerm_network_interface" "compute_nic" {
  name                = "${var.name_prefix}-vm-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "compute_nsg_assoc" {
  count                     = var.nsg_id == "" ? 0 : 1
  network_interface_id      = azurerm_network_interface.compute_nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_linux_virtual_machine" "compute_vm" {
  name                  = "${var.name_prefix}-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.compute_nic.id]

  admin_username                = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = var.cloud_init

  tags = var.tags
}
