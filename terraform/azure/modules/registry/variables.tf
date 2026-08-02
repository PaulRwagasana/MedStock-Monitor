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

variable "enable_acr_pull" {
  description = "Whether to create the AcrPull role assignment. Kept separate from principal_id since principal_id is often unknown until apply, and count/for_each cannot depend on unknown values."
  type        = bool
  default     = true
}
