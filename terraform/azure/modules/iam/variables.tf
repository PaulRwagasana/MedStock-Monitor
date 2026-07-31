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

  validation {
    condition = (
      var.ci_principal_id == "" ||
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.ci_principal_id))
    )
    error_message = "ci_principal_id must be empty or a valid Azure AD object ID (UUID), e.g. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx. Do not use the application (client) ID."
  }
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
