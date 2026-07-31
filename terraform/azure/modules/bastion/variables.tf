variable "resource_group_name" {
  description = "Resource group where bastion resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "medstock"
}

variable "subnet_id" {
  description = "Subnet ID (public subnet) where the bastion NIC will be placed"
  type        = string
}

variable "vm_size" {
  description = "Size of the bastion VM"
  type        = string
  default     = "Standard_B1s"
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

variable "allowed_ssh_cidrs" {
  description = "List of CIDRs allowed to SSH to the bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
