resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${var.name_prefix}-db"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  delegated_subnet_id    = var.subnet_id
  sku_name               = var.sku_name
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  storage_mb             = var.storage_mb
  backup_retention_days  = 7
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "timezone" {
  server_id = azurerm_postgresql_flexible_server.db.id
  name      = "timezone"
  value     = "UTC"
}

resource "azurerm_private_endpoint" "db_private_endpoint" {
  name                = "${var.name_prefix}-db-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-db-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

