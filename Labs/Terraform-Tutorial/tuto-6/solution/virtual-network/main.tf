#############
# RESOURCES #
#############

locals {
  location = "France Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = local.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_spaces
}

resource "azurerm_subnet" "subnets" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet }
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}