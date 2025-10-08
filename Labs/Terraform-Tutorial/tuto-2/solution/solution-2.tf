provider "azurerm" {
  features {}
}

module "rg" {
  source = "./resource-group"

  resource_group_name = "TUTO-RG-TSG"
}

output "id" {
  value = module.rg.resource_group_id
}