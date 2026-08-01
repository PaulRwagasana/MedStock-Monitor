variable "resource_group_name" {
  description = "Resource group for ACR"
  type        = string
}

variable "location" {
  description = "Azure location for ACR"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming ACR resource"
  type        = string
  default     = "medstock"
}

variable "sku" {
  description = "ACR SKU"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Whether ACR admin user is enabled"
  type        = bool
  default     = false
}

variable "principal_id" {
  description = "Principal ID to assign AcrPull role to"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to ACR"
  type        = map(string)
  default     = {}
}
