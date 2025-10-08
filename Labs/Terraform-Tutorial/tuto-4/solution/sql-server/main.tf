#############
# RESOURCES #
#############

locals {
  location = "France Central"
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = lower(var.sql_server_name)
  resource_group_name          = var.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "db" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.sqlserver.id
  sku_name       = "Basic"
}

resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}