#############
# RESOURCES #
#############

locals {
  location = "France Central"
}

resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = local.location
  resource_group_name = var.resource_group_name

  sku {
    tier = var.sku.tier
    size = var.sku.size
  }
}

resource "azurerm_app_service" "as" {
  name                = lower(var.app_service_name)
  location            = local.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}