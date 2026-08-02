# checkov:skip=CKV_AZURE_163: Vulnerability scanning requires Microsoft Defender for Cloud container registry plan (Standard or Premium SKU), which is out of scope for this student subscription. Accepted risk; would enable in production.
resource "azurerm_container_registry" "acr" {
  name                = "${var.name_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull_role" {
  count                = var.enable_acr_pull ? 1 : 0
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.principal_id
}
