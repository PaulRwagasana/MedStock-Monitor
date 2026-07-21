variable "network_name" {
  description = "Name of the Docker network used by the MedStock services."
  type        = string
  default     = "medstock-network"
}

variable "backend_container_name" {
  description = "Name of the backend container."
  type        = string
  default     = "medstock-backend"
}

variable "postgres_container_name" {
  description = "Name of the PostgreSQL container."
  type        = string
  default     = "medstock-db"
}

variable "postgres_image_name" {
  description = "Docker image for PostgreSQL."
  type        = string
  default     = "postgres"
}

variable "postgres_image_tag" {
  description = "Tag for the PostgreSQL image."
  type        = string
  default     = "15"
}

variable "backend_image_name" {
  description = "Docker image for the backend application."
  type        = string
  default     = "medstock-backend"
}

variable "backend_image_tag" {
  description = "Tag for the backend image."
  type        = string
  default     = "local"
}

variable "backend_internal_port" {
  description = "Port exposed inside the backend container."
  type        = number
  default     = 5000
}

variable "backend_external_port" {
  description = "Host port mapped to the backend container."
  type        = number
  default     = 5000
}

variable "postgres_external_port" {
  description = "Host port mapped to PostgreSQL."
  type        = number
  default     = 5432
}

variable "db_user" {
  description = "Database username for the application."
  type        = string
  default     = "medstock"
}

variable "db_password" {
  description = "Database password for the application."
  type        = string
  default     = "medstockpass"
}

variable "db_name" {
  description = "Database name for the application."
  type        = string
  default     = "medstock"
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
  default     = "dev"
}
