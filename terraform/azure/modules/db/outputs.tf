output "db_fqdn" {
  description = "FQDN for PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "db_id" {
  description = "Azure PostgreSQL server resource ID"
  value       = azurerm_postgresql_flexible_server.db.id
}

output "db_username" {
  description = "PostgreSQL administrator username"
  value       = azurerm_postgresql_flexible_server.db.administrator_login
}
