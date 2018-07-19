provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

locals {
  env                   = "${var.environment[terraform.workspace]}"
  secrets               = "${var.secrets[terraform.workspace]}"
  stack                 = "${var.stack_config[terraform.workspace]}"
  stack_name            = "${local.stack["name"]}"

  env_name              = "${terraform.workspace}"

  location              = "${local.env["location"]}"
  rg_name               = "${local.stack["rg_name_prefix"]}-${local.stack_name}-${local.env_name}"
  sql_server_name       = "${local.stack["sql_server_name_prefix"]}${local.env_name}"
  sql_admin_username    = "${local.stack["sql_admin_username"]}"
  sql_admin_password    = "${local.secrets["sql_admin_password"]}"
  db_name               = "${local.stack["db_name"]}"
  db_edition            = "${local.env["db.edition"]}"
  db_sku                = "${local.env["db.sku"]}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.rg_name}"
  location = "${local.location}"
}

resource "azurerm_sql_server" "sql" {
  name                          = "${local.sql_server_name}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  location                      = "${local.location}"
  version                       = "12.0"
  administrator_login           = "${local.sql_admin_username}"
  administrator_login_password  = "${local.sql_admin_password}"

  tags {
    environment = "${terraform.workspace}"
  }
}

resource "azurerm_sql_database" "db" {
  name                              = "${local.db_name}"
  resource_group_name               = "${azurerm_resource_group.rg.name}"
  location                          = "${local.location}"
  server_name                       = "${azurerm_sql_server.sql.name}"

  edition                           = "${local.db_edition}"
  requested_service_objective_name  = "${local.db_sku}"

  tags {
    environment = "${terraform.workspace}"
  }
}