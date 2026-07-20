variable "resource_group_name" {
  description = "Name of the Azure resource group for the MedStock infrastructure."
  type        = string
  default     = "rg-medstock-dev"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment tag."
  type        = string
  default     = "dev"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "vnet-medstock-dev"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the application subnet."
  type        = string
  default     = "snet-app"
}

variable "subnet_address_prefixes" {
  description = "CIDR block for the application subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "nsg_name" {
  description = "Name of the network security group."
  type        = string
  default     = "nsg-medstock-dev"
}

variable "allowed_source_ip" {
  description = "CIDR block allowed to reach the application over SSH and HTTP."
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port used by the application backend."
  type        = number
  default     = 5000
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    project     = "medstock-monitor"
    environment = "dev"
    managedBy   = "terraform"
  }
}
