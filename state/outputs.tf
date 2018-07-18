output "azurerm_storage_account.tfstate.primary_access_key" {
  value = "${azurerm_storage_account.state.primary_access_key}"
}