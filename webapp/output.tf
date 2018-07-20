output "webapp.url" {
  value = "http://${azurerm_app_service.webapp.name}.azurewebsites.net"
}

output "webapp.slot.urls" {
  value = ["${formatlist("http://${azurerm_app_service.webapp.name}-%v.azurewebsites.net", azurerm_app_service_slot.slots.*.name)}"]
}