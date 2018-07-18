provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "state" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "state" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.state.name}"
  location                 = "${var.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "Storage"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "state" {
  name                  = "${var.state_storage_container_name}"
  resource_group_name   = "${azurerm_resource_group.state.name}"
  storage_account_name  = "${azurerm_storage_account.state.name}"
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}