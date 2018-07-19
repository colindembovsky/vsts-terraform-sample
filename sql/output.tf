output "connection_string" {
  value = "Server=tcp:${azurerm_sql_server.sql.name}.database.windows.net;Database=${azurerm_sql_database.db.name};User ID=${azurerm_sql_server.sql.administrator_login}@${azurerm_sql_server.sql.name};Password=${azurerm_sql_server.sql.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
}
