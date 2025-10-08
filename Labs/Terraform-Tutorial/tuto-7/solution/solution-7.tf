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

module "virtual-network" {
  source = "../../tuto-6/solution/virtual-network"

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = "TUTO-VNET-TSG"
  address_spaces       = ["10.10.0.0/20"]
  subnets = [
    {
      name             = "TUTO-SN-TSG-1"
      address_prefixes = ["10.10.0.0/28"]
    },
    {
      name             = "TUTO-SN-TSG-2"
      address_prefixes = ["10.10.0.16/28"]
    }
  ]
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
  source = "../../tuto-4/solution/sql-server"

  resource_group_name = module.rg.resource_group_name
  sql_server_name     = "TUTOSQLSERVERTSG"
  admin_login         = "admintsg"
  admin_password      = "#tuto@dm1n#"
  database_name       = "TUTO_DB"
}

module "application-gateway" {
  source = "./application-gateway"

  resource_group_name      = module.rg.resource_group_name
  application_gateway_name = "TUTO-AP-TSG"
  public_ip_name           = "TUTO-PIP-TSG"
  subnet_id                = module.virtual-network.subnet_ids["TUTO-SN-TSG-1"]

  tuto_app_service = {
    name     = "todo-list-app"
    hostname = module.app-service.site_hostname
  }
}

output "site_hostname" {
  value = module.app-service.site_hostname
}

output "public_ip_address" {
  value = module.application-gateway.public_ip_address
}