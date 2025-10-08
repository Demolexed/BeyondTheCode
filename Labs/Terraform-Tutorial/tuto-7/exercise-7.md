# Tutorial 7 : Application Gateway

Niveau de difficulté : ⭐⭐⭐⭐⭐    

## Schéma

![Schéma](../images/app_gw.png)

[Doc Application Gateway](https://docs.microsoft.com/fr-fr/azure/application-gateway/overview)

<br/>

## Démystification

Avant de commencer ce tuto, vous pouvez lire cette [article](https://docs.microsoft.com/fr-fr/azure/application-gateway/how-application-gateway-works) conçernant le fonctionnement d'un Application Gateway (⏱️ 4 min.).

## Création d'un Azure Application Gateway

1) Créer un module `application-gateway`.
    - `variables.tf` : Toutes les variables sont obligatoires
        ```bash
        variable "resource_group_name" {
            type        = string
            description = "Resource Group Name"
        }

        variable "application_gateway_name" {
            type        = string
            description = "Application Gateway Name."
        }

        variable "public_ip_name" {
            type        = string
            description = "Public IP Name."
        }

        variable "subnet_id" {
            type        = string
            description = "Subnet ID."
        }

        variable "tuto_app_service" {
            type = object({
                name     = string
                hostname = string 
            })
        }
        ```
    - `outputs.tf` :
        ```bash
        output "public_ip_address" {
            value = azurerm_public_ip.public_ip.ip_address
        }
        ```
    - `main.tf` :
        ```bash
        locals {
            location = "France Central"

            # puisque ces variables sont réutilisées - un bloc local rend cela plus maintenable 
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
            
            # L'application gateway est rattaché à un sous-réseau (créé au préalable par le module "virtual-network") 
            gateway_ip_configuration {
                name      = "tuto-gateway-ip-configuration"
                subnet_id = var.subnet_id
            }

            # Un application gateway dispose d'une IP publique sur laquelle toutes les requêtes vont être redirigées
            frontend_ip_configuration {
                name                 = local.frontend_ip_configuration_name
                public_ip_address_id = azurerm_public_ip.public_ip.id
            }

            # Bloc frontend où l'on définit le port.  
            frontend_port {    
                name = local.frontend_port_name
                port = 80
            }

            # Ecouteur de l'URL entrante
            http_listener {
                name                           = local.listener_name
                frontend_ip_configuration_name = local.frontend_ip_configuration_name
                frontend_port_name             = local.frontend_port_name
                protocol                       = "Http"
            }

            Le pool de back-ends est utilisé pour router les demandes vers les serveurs back-end qui les traitent. Le pool de back-ends peut se composer de groupes de machines virtuelles identiques, d’adresses IP publiques, d’adresses IP internes ou encore d'Azure App Service.
            backend_address_pool {
                name  = local.backend_address_pool_name
                fqdns = [var.tuto_app_service.hostname]
            }
            
            # La sonde est rattaché au paramétrage backend_http_settings d'un Backend
            # Permet de vérifier que le backend est opérationnelle.
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

            # Paramétrage lié à un backend.
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

            # vous allez connecter le front-end et le pool de back-ends que vous avez créés à l’aide d’une règle de routage.
            request_routing_rule {
                name                       = local.request_routing_rule_name
                rule_type                  = "Basic"
                http_listener_name         = local.listener_name
                backend_address_pool_name  = local.backend_address_pool_name
                backend_http_settings_name = local.http_setting_name
            }
        }
        ```

   NB: La location sera "France Central" pour toutes les ressources.  

2) Dans le fichier `tuto-7.tf`, déclarer les modules `resource-group`, `app-service`, `sql-server`, `virtual-network` et enfin `application-gateway` tel que :  
    ```bash
    # Reprendre la déclaration des modules `resource-group`, `app-service`, `sql-server`, `virtual-network` dans les tutos précédents. Toujours adapter chaque `source` de module en fonction des tutos déjà développés.

    module "application-gateway" {
        source = "./application-gateway"

        resource_group_name      = module.rg.resource_group_name
        application_gateway_name = "TUTO-AP-[TRIGRAMME]"
        public_ip_name           = "TUTO-PIP-[TRIGRAMME]"
        subnet_id                = module.virtual-network.subnet_ids["TUTO-SN-[TRIGRAMME]-1"]

        tuto_app_service = {
            name     = "todo-list-app"
            hostname = module.app-service.site_hostname
        }
    }
    
    output "public_ip_address" {
      value = module.application-gateway.public_ip_address
    }
    ```
   
3) Exécuer votre code terraform et vérifier à travers le [portail Azure](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups) que vos ressources ont bien été créées.

4) Après la création de toutes vos ressources, vous aurez en sortie l'adresse IP public en sortie `public_ip_address`. Copiez-la dans la barre de recherche d'un navigateur.
   
5) Détruire les ressources.

## Rappels

### Rappel de la syntaxe Terraform

[ici](../memo.md)  

### Rappel des commandes Terraform

```bash
terraform init

terraform plan

terraform apply [-auto-approve]

terraform destroy
```
