# Tutorial 2 : Les modules  

Niveau de difficulté : ⭐  

## Définition : Module Terraform

Un module est tout simplement une partie de votre code Terraform que vous placez à l'intérieur d'un répertoire et que vous réutilisez à plusieurs endroits dans votre code. Au lieu donc d'avoir le même code copié et collé dans les différents projets, vous pourrez demander à vos différentes équipes de réutiliser le code du même module.  
  
En effet, les modules sont l'ingrédient clé pour écrire du **code Terraform réutilisable, maintenable et testable**. Une fois que vous commencez à les utiliser, vous ne pouvez plus vous en passer. C'est d'ailleurs une bonne pratique de commencer à écrire votre configuration en pensant aux modules, pour les intégrer dans votre bibliothèque de modules qui seront ensuite partagées au sein de votre entreprise.  
  
## Création d'un Azure Resource Group sous forme de Module Terraform

1) En s'inspirant du tuto-1, créer le module `resource-group`. Pour ce faire, vous trouverez dans le dossier `my-work`, le sous-dossier `resource-group` dans lequel se trouve les 4 fichiers suivants `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` :
   - `main.tf` : contiendra le code principal de votre configuration Terraform de votre module.  
     ```bash
     resource "azurerm_resource_group" "example" {
       location = "France Central"
       name     = var.resource_group_name
     }
     ```
   - `variables.tf` : contiendra les variables de votre module. Lorsque votre module est utilisé par d'autres, les variables seront configurées comme arguments dans le bloc module que nous verrons plus tard dans les tutos. ([Rappel syntaxe](./../memo.md##variable))  
     - `resource_group_name` : type string, Nom du Resource Group
     ```bash
     variable "resource_group_name" {
       ...
     }
     ```
   - `outputs.tf` : comme son nom l'indique, il contiendra les variables de sortie de votre module. Elles sont souvent utilisées pour transmettre des informations sur les parties de votre infrastructure définies par le module à d'autres parties de votre configuration. ([Rappel syntaxe](./../memo.md##output))  
     - `resource_group_id` : Resource ID du Resource Group
     - `resource_group_name` : Nom du Resource Group
     ```bash
     output "resource_group_id" {
       value = ...
     }

     output "resource_group_name" {
       value = azurerm_resource_group.example.name
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
 
2) Toujours dans le dossier `my-work`, ouvrir le fichier `tuto-2.tf` et instancier le module `resource-group`.
   ```bash
   # NB : le provider est instancié une seule fois ici dans le fichier de configuration principal
   provider "azurerm" {
    features {}
   }

   module "rg" {
    source = ...
     ...
   }
   ```
  
3) Afficher également l'id et le name du Resource Group en sortie.
   ```bash
   output "resource_group_id" {
      value = module.rg.resource_group_id
   }
   
   output "resource_group_name" {
      value = module.rg.resource_group_name
   }   
   ```
4) Initialiser puis exécuter votre code à l'aide des commandes Terraform. ([Rappel des commandes ci-dessous](#rappels))
   
5) Vérifier à travers le portail Azure que vos ressources ont bien été créées. Vous pouvez rechercher votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).
   
6) Détruire la ressource.

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