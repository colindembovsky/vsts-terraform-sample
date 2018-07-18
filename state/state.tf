# If you're recreating this from scratch, comment the backend block out,
# run `terraform apply`, update your access_key in secrets.tfvars and backend.tfvars, uncomment the backend block,
# run `terraform init`, and enter `yes` to copy your local state
# NOTE:  this is pre-configuration, these values need to be static; variable interpolation will fail
terraform {
  backend "azurerm" {
    resource_group_name  = "cd-terraform-rg"
    storage_account_name = "cdterrastatesa"
    container_name       = "state"
    key                  = "root.terraform.tfstate"
  }
}