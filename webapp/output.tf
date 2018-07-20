output "webapp.url" {
  value = "http://${azurerm_app_service.webapp.name}.azurewebsites.net"
}

output "webapp.slot.url" {
  value = "http://${azurerm_app_service.webapp.name}-${azurerm_app_service_slot.slot.name}.azurewebsites.net"
}