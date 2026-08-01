variable "resource_group_name" {
  description = "Resource group where compute resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "medstock"
}

variable "subnet_id" {
  description = "Subnet ID (private subnet) where the VM NIC will be placed"
  type        = string
}

variable "nsg_id" {
  description = "Optional NSG ID to associate with the VM NIC"
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B1ms"
}

variable "admin_username" {
  description = "Admin username for SSH"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user (openSSH format)"
  type        = string
}

variable "cloud_init" {
  description = "cloud-init / custom_data script to run on first boot"
  type        = string
  default     = <<-EOT
#cloud-config
package_update: true
packages:
  - docker.io
runcmd:
  - [ sh, -c, 'usermod -aG docker azureuser' ]
  - [ sh, -c, 'systemctl enable --now docker' ]
EOT
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
