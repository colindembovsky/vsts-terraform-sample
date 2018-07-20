provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

data "terraform_remote_state" "sql" {
  backend = "azurerm"
  workspace = "${terraform.workspace}"
  config = {
    resource_group_name  = "cd-terraform-rg"
    storage_account_name = "cdterrastatesa"
    container_name       = "state"
    key                  = "sql.terraform.tfstate"
    access_key           = "${var.access_key}"
  }
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
  plan_name             = "${local.stack["plan_name_prefix"]}-${local.env_name}"
  app_name              = "${local.stack["app_name_prefix"]}-${local.env_name}"
  plan_tier             = "${local.env["webapp.tier"]}"
  plan_sku              = "${local.env["webapp.sku"]}"
  db_con_str            = "${data.terraform_remote_state.sql.connection_string}"
}

resource "azurerm_resource_group" "apprg" {
  name     = "${local.rg_name}"
  location = "${local.location}"

  tags {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
  }
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${local.plan_name}"
  location            = "${local.location}"
  resource_group_name = "${local.rg_name}"

  sku {
    tier = "${local.plan_tier}"
    size = "${local.plan_sku}"
  }

  tags {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "${local.app_name}"
  location            = "${local.location}"
  resource_group_name = "${local.rg_name}"
  app_service_plan_id = "${azurerm_app_service_plan.plan.id}"

#   site_config {
#     dotnet_framework_version = "v4.0"
#   }

  app_settings {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Default"
    type  = "SQLServer"
    value = "${local.db_con_str}"
  }

  tags {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
  }
}

resource "azurerm_app_service_slot" "slot" {
  name                = "blue"
  app_service_name    = "${local.app_name}"
  location            = "${local.location}"
  resource_group_name = "${local.rg_name}"
  app_service_plan_id = "${azurerm_app_service_plan.plan.id}"

#   site_config {
#     dotnet_framework_version = "v4.0"
#   }

  app_settings {
    "SOME_KEY" = "blue-value"
  }

  connection_string {
    name  = "Default"
    type  = "SQLServer"
    value = "${local.db_con_str}"
  }

  tags {
    environment = "${terraform.workspace}"
    created_by  = "${local.created_by}"
  }
}