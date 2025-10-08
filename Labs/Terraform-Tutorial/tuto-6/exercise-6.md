# Tutorial 6 : Virtual Network  

Niveau de difficulté : ⭐⭐⭐  

## Schéma

![Schéma](../images/vnet.png)

[Doc Virtual Network](https://docs.microsoft.com/fr-fr/azure/virtual-network/virtual-networks-overview)

<br/>

## Démystification

Pourquoi mettre en place un Virtual Network (ou réseau virtuel in french) ?  
=> Cela va nous permettre de regrouper nos ressources Azure au sein d'un même réseau. 
Chaque type de ressources pourra ensuite être associé à un sous-réseau (Subnet) de ce réseau.
Ci-dessous l'exemple d'un Vnet avec une plage IP `10.10.0.0/20`, ce qui nous donne la possibilité d'avoir un réseau avec 4096 adresses IP disponibles (`10.10.0.0` à `10.10.15.255`).  
De plus, ce réseau contient deux sous-réseaux :
  - `SUBNET-APP` avec la plage IP `10.10.0.0/24` : 64 adresses IP allouées (`10.10.0.0` à `10.10.0.255`)  
  - `SUBNET-DB` avec la plage IP `10.10.1.0/24` : 64 adresses IP allouées (`10.10.1.0` à `10.10.1.255`)

NB: Chaque App Service/Base de données sera associé à une adresse IP, donc il en reste 252 sur 255 disponibles dans chaque sous-réseau.  
Vous pouvez calculer vos plages d'adresses IP grâce à cet [outil en ligne](https://www.davidc.net/sites/default/subnets/subnets.html)   
Le choix des plages d'adresses IP dépend de votre organisation.

![Schéma](../images/vnet_use_case.png)

<br />

## Création d'un Azure Virtual Network

1) Créer un module `virtual-network` qui permet d'instancier un [Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) avec des [Subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet).
    - `variables.tf` : 
      - `resource_group_name` : string
      - `virtual_network_name` : string
      - `address_spaces` : list(string)
      - `subnets` : list(object({ name = string, address_prefixes = list(string) }))      
    - `outputs.tf` :
      - `subnet_ids` : liste des Resource ID de chaque subnet.
      ```bash
        output "subnet_ids" {
          value = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.id }
        }
      ```
    - `main.tf` :
      ```bash
      locals {
        location = "France Central"
      }

      resource "azurerm_virtual_network" "vnet" {
        location            = local.location
        ...
        # Renseigner les champs obligatoires (Required)
        
        # Doc : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
      }

      resource "azurerm_subnet" "subnets" {
        for_each             = { for subnet in var.subnets : subnet.name => subnet }
        ...
        # Renseigner les champs obligatoires (Required)
        # Renseigner également le champ : address_prefixes

        # Doc : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
      }
      ```
    
   NB: La location sera "France Central" pour toutes les ressources.

2) Dans le fichier `tuto-6.tf`, déclarer les modules `resource-group` et `virtual-network` :  
   - `resource_group_name` : `"TUTO-RG-[TRIGRAMME]"`
   - `virtual_network_name` : `"TUTO-VNET-[TRIGRAMME]"`
   - `address_space` : `["10.10.0.0/20"]`
   - `subnets` : 2 subnets :
     - name = `TUTO-SN-[TRIGRAMME]-1`, address_prefix = `"10.10.0.0/28"`
     - name = `TUTO-SN-[TRIGRAMME]-2`, address_prefix = `"10.10.0.16/28"`
      ```bash
      # NB : le provider est instancié une seule fois ici dans le fichier de configuration principal
      provider "azurerm" {
        features {}
      }

      module "rg" {
        source = "../../tuto-2/my-work/resource-group" # Adapter le chemin vers le module du tuto-2
        resource_group_name = "TUTO-RG-[TRIGRAMME]"
      }

      module "virtual-network" {
        source = "./virtual-network"
        ...
      }

      # Outputs
      output "subnet_ids" {
        value = module.virtual-network.subnet_ids
      }
      ```

3) Initialiser puis exécuter votre code à l'aide des commandes Terraform. ([Rappel des commandes ci-dessous](#rappels))
   
4) Vérifier à travers le portail Azure que vos ressources ont bien été créées. Vous pouvez rechercher votre Resource Group [ici](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).
 
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
