variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default     = "westus2"
  description = "The location in which to deploy the module."
}

variable "resource_group_name" {
  default     = "cd-terraform-rg"
  description = "The name of the resource group to create. This should not be an existing storage account."
}

variable "storage_account_name" {
  default     = "cdterrastatesa"
  description = "The name of the storage account to create."
}

variable "state_storage_container_name" {
  default     = "state"
  description = "The name of the storage container to create."
}
