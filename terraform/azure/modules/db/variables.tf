variable "resource_group_name" {
  description = "Resource group where the PostgreSQL server will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming DB resources"
  type        = string
  default     = "medstock"
}

variable "sku_name" {
  description = "SKU name for PostgreSQL flexible server"
  type        = string
  default     = "Standard_B1ms"
}

variable "tier" {
  description = "Tier for PostgreSQL flexible server"
  type        = string
  default     = "Burstable"
}

variable "version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "14"
}

variable "administrator_login" {
  description = "Administrator login for PostgreSQL"
  type        = string
  default     = "psqladmin"
}

variable "administrator_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "private_dns_zone_id" {
  description = "Optional private DNS zone ID for the private endpoint"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
