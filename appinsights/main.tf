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
  created_by            = "${var.created_by}"
  stack_name            = "${local.stack["name"]}"

  env_name              = "${terraform.workspace}"

  location              = "${local.env["location"]}"
  rg_name               = "${local.stack["rg_name_prefix"]}-${local.stack_name}-${local.env_name}"
  app_name              = "${local.stack["app_name_prefix"]}-${local.env_name}"
  appinsights_name      = "${local.stack["app_name_prefix"]}-ai-${local.env_name}"
}

resource "azurerm_resource_group" "airg" {
  name     = "${local.rg_name}"
  location = "${local.location}"

  tags {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
  }
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${local.appinsights_name}"
  location            = "${azurerm_resource_group.airg.location}"
  resource_group_name = "${azurerm_resource_group.airg.name}"
  application_type    = "Web"

  tags = {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
    webapp      = "${local.app_name}"
  }
}

