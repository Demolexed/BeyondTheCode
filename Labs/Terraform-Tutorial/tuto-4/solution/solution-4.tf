provider "azurerm" {
  features {}
}

locals {
  resource_group_name = "TUTO-RG-TSG"
}

module "rg" {
  source = "../../tuto-2/solution/resource-group"

  resource_group_name = local.resource_group_name
}

module "app-service" {
  source = "../../tuto-3/solution/app-service"

  resource_group_name   = module.rg.resource_group_name
  app_service_plan_name = "TUTO-ASP-TSG"
  app_service_name      = "TUTO-AS-TSG"

  sku = {
    tier = "Free"
    size = "F1"
  }
}

module "sql-server" {
  source = "./sql-server"

  resource_group_name = module.rg.resource_group_name
  sql_server_name     = "TUTOSQLSERVERTSG"
  admin_login         = "admintsg"
  admin_password      = "#tuto@dm1n#" # au moins 8 caractères
  database_name       = "TUTO_DB"
}

output "site_hostname" {
  value = module.app-service.site_hostname
}