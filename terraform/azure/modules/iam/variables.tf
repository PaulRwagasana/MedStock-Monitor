variable "resource_group_name" {
  description = "Name of the existing Azure resource group used for optional Reader role assignment."
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the existing Azure Container Registry (from module.registry)."
  type        = string
}

variable "ci_principal_id" {
  description = "Object ID of the CI/CD service principal that should receive IAM role assignments. Leave empty to skip assignments."
  type        = string
  default     = ""
}

variable "enable_acr_push" {
  description = "Grant the CI/CD service principal AcrPush on the existing ACR."
  type        = bool
  default     = true
}

variable "enable_rg_reader" {
  description = "Grant the CI/CD service principal Reader on the existing resource group."
  type        = bool
  default     = true
}
