variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "rg-medstock-monitor"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "medstock-vnet"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_name" {
  description = "Name of the public subnet for the bastion host."
  type        = string
  default     = "medstock-public-subnet"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_name" {
  description = "Name of the private subnet for the application VM."
  type        = string
  default     = "medstock-private-subnet"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.10.2.0/24"
}

variable "bastion_vm_name" {
  description = "Name of the bastion host VM."
  type        = string
  default     = "medstock-bastion"
}

variable "app_vm_name" {
  description = "Name of the application VM."
  type        = string
  default     = "medstock-app"
}

variable "admin_username" {
  description = "Admin username for both VMs."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for both VMs."
  type        = string
  sensitive   = true
}

variable "postgres_server_name" {
  description = "Globally unique name for the Azure Database for PostgreSQL flexible server."
  type        = string
  default     = "medstock-psql-server"
}

variable "db_name" {
  description = "PostgreSQL database name."
  type        = string
  default     = "medstock"
}

variable "db_user" {
  description = "PostgreSQL username."
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "PostgreSQL password."
  type        = string
  sensitive   = true
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name."
  type        = string
  default     = "medstockacr"
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry."
  type        = string
  default     = "Basic"
}
