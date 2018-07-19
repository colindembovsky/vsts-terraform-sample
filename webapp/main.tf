provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "apprg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.svc_plan_name}"
  location            = "${azurerm_resource_group.apprg.location}"
  resource_group_name = "${azurerm_resource_group.apprg.name}"

  sku {
    tier = "${var.svc_plan_tier}"
    size = "${var.svc_plan_size}"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "${var.web_app_name}"
  location            = "${azurerm_resource_group.apprg.location}"
  resource_group_name = "${azurerm_resource_group.apprg.name}"
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
    value = "Server=tcp:${var.sql_server}.database.windows.net;Database=${var.sql_db};User ID=${var.sql_admin}@${var.sql_server};Password=${var.sql_password};Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_app_service_slot" "slot" {
  name                = "blue"
  app_service_name    = "${azurerm_app_service.webapp.name}"
  location            = "${azurerm_resource_group.apprg.location}"
  resource_group_name = "${azurerm_resource_group.apprg.name}"
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
    value = "Server=tcp:${var.sql_server}.database.windows.net;Database=${var.sql_db};User ID=${var.sql_admin}@${var.sql_server};Password=${var.sql_password};Trusted_Connection=False;Encrypt=True;"
  }
}