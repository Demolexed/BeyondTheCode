#############
# RESOURCES #
#############

locals {
  location = "France Central"

  # since these variables are re-used - a locals block makes this more maintainable  
  backend_address_pool_name      = "${var.tuto_app_service.name}-beap"
  frontend_port_name             = "${var.tuto_app_service.name}-feport"
  frontend_ip_configuration_name = "${var.tuto_app_service.name}-feip"
  http_setting_name              = "${var.tuto_app_service.name}-be-htst"
  listener_name                  = "${var.tuto_app_service.name}-httplstn"
  request_routing_rule_name      = "${var.tuto_app_service.name}-rqrt"
  probe_name                     = "${var.tuto_app_service.name}-hp"
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = local.location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "network" {
  name                = var.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = local.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "tuto-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_port {    
    name = local.frontend_port_name
    port = 80
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [var.tuto_app_service.hostname]
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
    probe_name                          = local.probe_name
  }

  probe {
    name                                      = local.probe_name
    pick_host_name_from_backend_http_settings = true
    interval                                  = 60
    protocol                                  = "Http"
    timeout                                   = 30
    path                                      = "/"
    unhealthy_threshold                       = 5
    match {
      status_code = ["200-399"]
    }    
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}