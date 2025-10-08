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
  source = "./app-service"

  resource_group_name   = module.rg.resource_group_name # ou local.resource_group_name avec meta-arguments depends_on = [module.rg]
  app_service_plan_name = "TUTO-ASP-TSG"
  app_service_name      = "TUTO-AS-TSG"

  sku = {
    tier = "Free"
    size = "F1"
  }

  # depends_on = [module.rg]
}

output "site_hostname" {
  value = module.app-service.site_hostname
}