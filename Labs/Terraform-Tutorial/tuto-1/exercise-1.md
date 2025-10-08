# Tutorial 1 : Premier pas

Niveau de difficulté : ⭐  

## Schéma

![Schéma](../images/rg.png)

[Doc Resource Group](https://docs.microsoft.com/fr-fr/azure/azure-resource-manager/management/overview#resource-groups)

<br/>

## Définition : Azure Resource Group

Un Resoure Group est une forme de dossier où l'on va ranger nos ressources Azure (une VM, une base de données, etc...).  
L'organisation des ressources dans des Resource Groups permet de gérer plus simplement un groupe de ressources (contrôle d'accès, verrouillage, tags).  

## Pré-requis

Dans votre terminal préféré, connectez-vous à Azure avec votre compte AD Cdiscount et mettez vous sur la souscription `BA02AZRPAY001` avec les lignes de commande suivantes : 
   
   ```powershell
   az login # Redirection vers une page web de connexion à Azure
   az account set --subscription BA02AZRPAY001 # Souscription Hors Prod
   ```

## Création d'un Azure Resource Group

1) Vous trouverez dans le dossier `my-work` le fichier `tuto-1.tf`. Modifier ce fichier en ajoutant le provider [`azurerm`](https://registry.terraform.io/providers/hashicorp/azurerm/latest) et l'instancier.
   ```bash
   terraform {
      required_providers {
         azurerm = {
           source  = "hashicorp/azurerm"
           version = "2.50.0"
         }
      }
   }

   # Instanciation du provider
   provider "azurerm" {
      features {} # Bloc obligatoire pour ce provider.
   }
   ```

2) Décrire ensuite la création d'un [Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group). Cette ressource requiert les champs `name` et `location` :
   - `name` : string commençant par `TUTO-RG-` et suivi de votre TRIGRAMME
   - `location` : string représentant la région où est créée le Resource Group (ici "France Central")
   ```bash
   resource "azurerm_resource_group" "example" {
      name     = "TUTO-RG-[TRIGRAMME]"
      location = "France Central"
   }
   ```  

3) Décrire un output : ([Rappel syntaxe](./../memo.md##output))
   - `resource_group_id` : l'identifiant du Resource Group qui sera créé sur Azure
   ```bash
   output "resource_group_id" {
      value = azurerm_resource_group.example.id
   }
   ```

4) Ouvrir votre terminal et se placer dans le dossier où se trouve votre fichier `tuto-1.tf`.
   
5) À l'aide des commandes Terraform ([Rappel des commandes ci-dessous](#rappels)), initialiser puis exécuter un plan afin d'observer les modifications qu'apportera Terraform.
   
6) Appliquer le plan.

7) Vérifier à travers le portail Azure que votre Resource Group a bien été créé. Vous pouvez rechercher votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).
   
8) Détruire la ressource.

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
