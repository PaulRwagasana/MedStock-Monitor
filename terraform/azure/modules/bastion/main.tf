resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.name_prefix}-bastion-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "${var.name_prefix}-bastion-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ssh_cidrs
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_interface" "bastion_nic" {
  name                = "${var.name_prefix}-bastion-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_pip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "assoc" {
  network_interface_id       = azurerm_network_interface.bastion_nic.id
  network_security_group_id  = azurerm_network_security_group.bastion_nsg.id
}

resource "azurerm_linux_virtual_machine" "bastion_vm" {
  name                  = "${var.name_prefix}-bastion-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]

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

  tags = var.tags
}
