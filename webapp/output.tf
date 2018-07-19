output "webapp.name" {
  value = "${azurerm_app_service.webapp.name}"
}

output "db_conn_str" {
  value = "${azurerm_app_service.webapp.connection_string.0.value}"
}
