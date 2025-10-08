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
  source = "./virtual-network"

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

output "subnet_ids" {
  value = module.virtual-network.subnet_ids
}