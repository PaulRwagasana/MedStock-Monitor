variable "resource_group_name" {
  description = "Azure resource group name for the deployment"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
  default     = "medstock"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for bastion and compute VM admin users"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_administrator_password" {
  description = "Password for the managed PostgreSQL admin user"
  type        = string
  sensitive   = true
}

variable "acr_admin_enabled" {
  description = "Whether to enable the admin user on Azure Container Registry"
  type        = bool
  default     = false
}

variable "client_id" {
  description = "Azure service principal client ID for explicit provider authentication"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Azure service principal client secret for explicit provider authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID for explicit provider authentication"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure subscription ID for explicit provider authentication"
  type        = string
  default     = ""
}
