# Tutorial 4 : Les dépendances entre ressources / modules  

Niveau de difficulté : ⭐⭐⭐    

## Schéma

![Schéma](../images/app_service.png)

[Doc App Service Plan](https://docs.microsoft.com/fr-fr/azure/app-service/overview-hosting-plans)  
[Doc App Service](https://docs.microsoft.com/fr-fr/azure/app-service/overview)

<br/>

## Création App Service Plan et App Service et déploiement d'une application web
  
1) Créer un module `app-service` qui permet d'instancier un [App Service Plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) et un [App Service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service)
  - `variables.tf` :
     - `resource_group_name` : string
     - `app_service_plan_name` : string
     - `app_service_name` : string
     - `sku` : objet composé de 2 strings `tier` et `size`
       ```bash
       variable "resource_group_name" {
          type        = string
          description = "Resource Group Name"
       }

       variable "app_service_plan_name" {
          type = string
       }

       variable "app_service_name" {
          type = string
       }

       variable "sku" {
          type = object({
            tier = string
            size = string
          })
       }
       ```
  - `main.tf` : ce fichier contiendra la définition des ressources.
    ```bash     
    locals {
      location = "France Central"
    }

    resource "azurerm_app_service_plan" "asp" {
      location            = local.location
      ...
    }

    resource "azurerm_app_service" "as" {
      location            = local.location
      ...
    
      # Récupération de l'ID de l'app service plan via le champ "id"
      app_service_plan_id = azurerm_app_service_plan.asp.id
    }
    ```
  - `outputs.tf` : ce fichier contiendra les outputs du module.
    - `site_hostname` : URL de l'App Service
    ```bash
    output "site_hostname" {
      value = azurerm_app_service.as.default_site_hostname
    }
    ```
  - `versions.tf` : ce fichier contiendra la définition des providers du module.
     - `azurerm` : Provider azurerm avec la dernière version  
     ```bash
     terraform {
       required_providers {
         azurerm = {
           source  = "hashicorp/azurerm"
           version = "2.50.0"
         }
       }
     }
     ```

   NB: La location sera "France Central" pour toutes les ressources.
   
2) Dans le dossier `my-work`, ouvrir le fichier `tuto-3.tf`.  
   Déclarer les modules `resource-group` et `app-service` tel que :  
   
   Le module `app-service` dépend du module `resource-group` car les ressources ont besoin d'être créées à l'intérieur d'un Resource Group.

   ```bash
   # NB : le provider est instancié une seule fois ici dans le fichier de configuration principal
   provider "azurerm" {
     features {}
   }

   module "rg" {
     source = "../../tuto-2/my-work/resource-group" # Adapter le chemin vers le module du tuto-2
     resource_group_name = "TUTO-RG-[TRIGRAMME]"
   }

   module "app-service" {
     source = "./app-service"
     resource_group_name   = module.rg.resource_group_name # dépendance avec le module resource-group
     app_service_plan_name = "TUTO-ASP-[TRIGRAMME]"
     app_service_name      = "TUTO-AS-[TRIGRAMME]"     
     sku = {
       tier = "Free"
       size = "F1"
     }
   }

   # Outputs
   output "site_hostname" {
     value = module.app-service.site_hostname
   }
   ```

3) Initialiser puis exécuter votre code à l'aide des commandes Terraform. ([Rappel des commandes ci-dessous](#rappels))
   
4) Vérifier à travers le portail Azure que vos ressources ont bien été créées. Vous pouvez rechercher votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).
 
5) Déployer l'application web **TodoListApp** via la ligne de commande suivante  

   ```bash
   az webapp deployment source config-zip --name TUTO-AS-[TRIGRAMME] --resource-group TUTO-RG-[TRIGRAMME] --src "$(git rev-parse --show-toplevel)/apps/todoListApp.zip"
   ```

6) Vérifier si l'application a bien été déployée : **https://tuto-as-[trigramme].azurewebsites.net**

7) Détruire les ressources.

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