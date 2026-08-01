output "db_fqdn" {
  description = "FQDN for PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "db_private_endpoint_id" {
  description = "Private endpoint ID for the database"
  value       = azurerm_private_endpoint.db_private_endpoint.id
}

output "db_id" {
  description = "Azure PostgreSQL server resource ID"
  value       = azurerm_postgresql_flexible_server.db.id
}

output "db_username" {
  description = "PostgreSQL administrator username"
  value       = azurerm_postgresql_flexible_server.db.administrator_login
}
