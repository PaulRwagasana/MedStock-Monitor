resource "azurerm_postgresql_flexible_server" "db" {
  name                          = "${var.name_prefix}-db"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgres_version
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  sku_name                      = var.sku_name
  administrator_login           = var.administrator_login
  administrator_password        = var.administrator_password
  storage_mb                    = var.storage_mb
  backup_retention_days         = 7

  lifecycle {
    ignore_changes = [zone]
  }
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "timezone" {
  server_id = azurerm_postgresql_flexible_server.db.id
  name      = "timezone"
  value     = "UTC"
}
