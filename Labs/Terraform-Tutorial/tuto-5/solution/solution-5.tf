terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  resource_group_names = ["RG1", "RG2", "RG3"]
  enable_create        = true
}

# for_each
resource "azurerm_resource_group" "rgs1" {
  for_each = { for i in local.resource_group_names : i => i }
  name     = "TUTO-RG-FOREACH-TSG${each.value}" # each.key car ici la clé est identique à sa valeur (i => i)
  location = "France Central"
}

# count
resource "azurerm_resource_group" "rgs2" {
  count    = 3
  name     = "TUTO-RG-COUNT-TSG${count.index + 1}"
  location = "France Central"
}

# count : if statement
resource "azurerm_resource_group" "rg" {
  count    = local.enable_create == true ? 1 : 0
  name     = "TUTO-RG-TSG"
  location = "France Central"
}