terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = var.client_id != "" ? var.client_id : null
  client_secret   = var.client_secret != "" ? var.client_secret : null
  tenant_id       = var.tenant_id != "" ? var.tenant_id : null
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}
