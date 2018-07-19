variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "environment" {
  type = "map"
}

variable "secrets" {
  type = "map"
}

variable "stack_config" {
  type = "map"

  default = {
    dev = {
      name                    = "webapp"
      sql_server_name_prefix  = "cdterrasql"
      sql_admin_name          = "tfadmin"
      db_name                 = "terraform_db"
    }
  }
}