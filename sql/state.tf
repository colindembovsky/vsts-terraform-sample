terraform {
  backend "azurerm" {
    resource_group_name  = "cd-terraform-rg"
    storage_account_name = "cdterrastatesa"
    container_name       = "state"
    key                  = "sql.terraform.tfstate"
  }
}