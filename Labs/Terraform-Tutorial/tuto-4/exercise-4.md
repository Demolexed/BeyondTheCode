# Tutorial 5 : App Service et SQL Server/Database  

Niveau de difficulté : ⭐⭐⭐  

## Schéma

![Schéma](../images/sql_server.png)

[Doc SQL Server](https://docs.microsoft.com/fr-fr/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)  

<br/>

## Création d'un serveur SQL avec Base de données, communication entre BDD et App Service

1) Créer un module `sql-server` qui permet d'instancier un [Serveur SQL](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) et une [base de données](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
   - `variables.tf` : 
     - `resource_group_name` : string 
     - `sql_server_name` : string en minuscule : vous pouvez utiliser la fonction [`lower()`](https://www.terraform.io/docs/language/functions/lower.html) de Terraform.
     - `admin_login` : string
     - `admin_password` : string
     - `database_name` : string
   - `outputs.tf` :
     - `sql_server_fqdn` : champ exporté de la ressource mssql_server => `fully_qualified_domain_name`
   - `main.tf` :
      ```bash
      resource "azurerm_mssql_server" "sqlserver" {
         ... 
         # Renseigner uniquement les champs obligatoires (Required)
         
         # Doc : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
      }
   
      resource "azurerm_mssql_database" "db" {
        ... 
        # Renseigner les champs obligatoires (Required)
        # Renseigner également le champ optionnel : sku_name = "Basic"
        
        # Doc : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database
      }

      # Ajouter cette ressource sql_firewall_rule afin d'autoriser les services Azure à accéder au Serveur SQL
      resource "azurerm_sql_firewall_rule" "allow_azure_services" {
        name                = "AllowAzureServices"
        resource_group_name = var.resource_group_name
        server_name         = azurerm_mssql_server.sqlserver.name
        start_ip_address    = "0.0.0.0"
        end_ip_address      = "0.0.0.0"
      }
      ```

   NB: La location sera "France Central" pour toutes les ressources.  

2) Dans le dossier `my-work`, ouvrir le fichier `tuto-4.tf` et déclarer les modules :     
   `resource-group` et `app-service` :  
      - Même configuration que dans le tuto-3.
      - Adapter le chemin `source` du module `app-service` vers le tuto-3.
      ```bash
      provider "azurerm" {
        features {}
      }

      module "rg" {
        source = "../../tuto-2/my-work/resource-group"
        resource_group_name = "TUTO-RG-[TRIGRAMME]"
      }

      module "app-service" {
        source = "../../tuto-3/my-work/app-service"

        resource_group_name   = module.rg.resource_group_name
        app_service_plan_name = "TUTO-ASP-[TRIGRAMME]"
        app_service_name      = "TUTO-AS-[TRIGRAMME]"

        sku = {
          tier = "Free"
          size = "F1"
        }
      }   
      ```
   `sql-server` : 
      - `resource_group_name` : `"TUTO-RG-[TRIGRAMME]"` (valeur récupérée en sortie du module `resource-group`)
      - `sql_server_name` : `"tutosqlserver[trigramme]"`
      - `admin_login` : à définir
      - `admin_password` : à définir (au moins 8 caractères)
      - `database_name` : `"TUTO_DB"`
      ```bash
      module "sql-server" {
        source = "./sql-server"

        resource_group_name = module.rg.resource_group_name
        sql_server_name     = "TUTOSQLSERVER[TRIGRAMME]"
        admin_login         = 
        admin_password      = # au moins 8 caractères
        database_name       = "TUTO_DB"
      }
      ```
3) Initialiser puis exécuter votre code à l'aide des commandes Terraform. ([Rappel des commandes ci-dessous](#rappels))
   
4) Vérifier à travers le portail Azure que vos ressources ont bien été créées. Vous pouvez rechercher votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).
 
5) Déployer l'application web via la ligne de commande suivante  

   ```bash
   az webapp deployment source config-zip --name TUTO-AS-[TRIGRAMME] --resource-group TUTO-RG-[TRIGRAMME] --src "$(git rev-parse --show-toplevel)/apps/todoListApp.zip"
   ```

6) Ajouter la Connection String suivante à l'App Service via Terraform ou le Portail Azure.
 
   ```bash
   # Connection string 
   Server=tcp:tutosqlserver[trigramme].database.windows.net,1433;Initial Catalog=TUTO_DB;Persist Security Info=False;User ID=[admin_login];Password=[admin_password];MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
   ```

   Avec Terraform :
   - Modifier votre module `app-service` en y ajoutant une variable d'entrée `connection_string` de type string dans le fichier `variables.tf`.
   - Cette variable sera utilisée dans la ressource `azurerm_app_service`
   - Ajouter le bloc `connection_string` suivant : 
      ```bash   
      resource "azurerm_app_service" "as" {
      ...
      
         connection_string {
            name  = "DefaultConnection"
            type  = "SQLAzure"
            value = var.connection_string
         }
      }
      ```
   - Dans la déclaration du module `app-service` dans le fichier `tuto-4.tf`, renseigner la nouvelle entrée `connection_string` avec la valeur ci-dessus.
   - A l'aide des commandes Terraform, relancer un plan puis appliquer les changements.    

   Avec le Portail Azure :  
   Recherchez et ouvrez votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).    
   Sélectionnez ensuite votre App Service (tuto-as-[trigramme]) et suivez les insctructions suivantes.

   ![connection_string_1](../images/connection_string_1.png)
   ![connection_string_2](../images/connection_string_2.png)

7) Tester l'application web et la Todo List App.
  
8) Détruire les ressources.

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
