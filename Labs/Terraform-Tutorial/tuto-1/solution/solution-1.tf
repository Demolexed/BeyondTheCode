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

resource "azurerm_resource_group" "rg" {
  name     = "TUTO-RG-TSG"
  location = "France Central"
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}