resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${var.name_prefix}-db"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.version
  delegated_subnet_id    = var.subnet_id
  sku_name               = var.sku_name
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  storage_mb             = var.storage_mb
  availability_zone      = "1"

  high_availability {
    mode = "Disabled"
  }

  backup {
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  network {
    delegated_subnet_resource_id = var.subnet_id
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "timezone" {
  name                 = "timezone"
  resource_group_name  = var.resource_group_name
  server_name          = azurerm_postgresql_flexible_server.db.name
  value                = "UTC"
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

resource "azurerm_private_dns_zone" "db_dns" {
  count = var.private_dns_zone_id == "" ? 1 : 0

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  count                = var.private_dns_zone_id == "" ? 1 : 0
  name                 = "${var.name_prefix}-db-dnslink"
  resource_group_name  = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.db_dns.name
  virtual_network_id   = azurerm_postgresql_flexible_server.db.delegated_subnet_resource_id
  registration_enabled = false
}
