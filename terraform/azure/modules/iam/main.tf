# IAM module — role assignments only.
# Does not create VMs, ACR, PostgreSQL, networking, or bastion resources.
# Consumes existing ACR / resource group identifiers from the root module.

data "azurerm_resource_group" "target" {
  count = var.enable_rg_reader && var.ci_principal_id != "" ? 1 : 0
  name  = var.resource_group_name
}

# CI/CD service principal needs AcrPush to publish images from GitHub Actions.
resource "azurerm_role_assignment" "ci_acr_push" {
  count = var.enable_acr_push && var.ci_principal_id != "" ? 1 : 0

  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.ci_principal_id
}

# Optional read access so CI can discover resource metadata without broad Contributor.
resource "azurerm_role_assignment" "ci_rg_reader" {
  count = var.enable_rg_reader && var.ci_principal_id != "" ? 1 : 0

  scope                = data.azurerm_resource_group.target[0].id
  role_definition_name = "Reader"
  principal_id         = var.ci_principal_id
}
