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


# TODO: Exemple for_each
resource "azurerm_resource_group" "for_each_example" {
  for_each =
  name     = "TUTO-RG-[TRIGRAMME]"
  location = "France Central"
}


# TODO: Exemple count
resource "azurerm_resource_group" "count_example" {
  count    =
  name     = "TUTO-RG-[TRIGRAMME]"
  location = "France Central"
}


# TODO: Exemple count condition
resource "azurerm_resource_group" "condition_example" {
  count    =
  name     = "TUTO-RG-[TRIGRAMME]"
  location = "France Central"
}