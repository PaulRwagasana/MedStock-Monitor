# ============================================================
# variables.tf
# Member 1 - Shared Terraform Variables (Docker)
# ============================================================

variable "network_name" {
  description = "Name of the Docker bridge network."
  type        = string
  default     = "medstock-network"
}

variable "backend_container_name" {
  description = "Name of the backend application container."
  type        = string
  default     = "medstock-backend"
}

variable "postgres_container_name" {
  description = "Name of the PostgreSQL container."
  type        = string
  default     = "medstock-db"
}

variable "backend_image" {
  description = "Backend application image."
  type        = string
  default     = "ghcr.io/cletusaabugre/medstock-monitor:ci"
}

variable "backend_internal_port" {
  description = "Port exposed inside the backend container."
  type        = number
  default     = 5000
}

variable "backend_external_port" {
  description = "Port exposed on the host."
  type        = number
  default     = 5000
}

variable "postgres_port" {
  description = "PostgreSQL port."
  type        = number
  default     = 5432
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
  default     = "postgres"
}
