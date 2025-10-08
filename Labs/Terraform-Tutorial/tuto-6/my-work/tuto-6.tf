provider "azurerm" {
    features {}
}

module "rg" {
  source = "../../tuto-2/my-work/resource-group"
  resource_group_name = ...
}


# TODO: J'instancie le module 'virtual-network'

module "vnet" {
  source = "./virtual-network"
  resource_group_name = ...
  ...
}

# TODO: Je décris mes outputs
