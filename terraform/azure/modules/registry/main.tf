resource "azurerm_container_registry" "acr" {
  name                = "${var.name_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  georeplications     = []

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull_role" {
  count                = var.principal_id == "" ? 0 : 1
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.principal_id
}
