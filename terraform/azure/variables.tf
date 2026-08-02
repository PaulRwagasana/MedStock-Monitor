variable "resource_group_name" {
  type    = string
  default = "rg-medstock-monitor"
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "name_prefix" {
  type    = string
  default = "medstockhbt"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_ssh_public_key" {
  type = string
}

variable "allowed_ssh_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "db_administrator_login" {
  type    = string
  default = "psqladmin"
}

variable "db_administrator_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = map(string)
  default = {
    project     = "medstock-monitor"
    environment = "production"
  }
}

variable "subscription_id" {
  type    = string
  default = ""
}

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "tenant_id" {
  type    = string
  default = ""
}
