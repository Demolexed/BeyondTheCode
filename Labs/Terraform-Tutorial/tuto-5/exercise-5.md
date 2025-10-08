# Tutorial 3 : Les boucles  

Niveau de difficulté : ⭐⭐    

## Manipulation des meta-arguments (`for_each`, `count`)

1) Ouvrir le fichier `tuto-5.tf` et ajouter le bloc suivant après la déclaration du provider :

   ```bash
   locals {
      resource_group_names = ["RG1", "RG2", "RG3"]
   }
   ```

2) A l'aide du meta-argument [`for_each`](https://www.terraform.io/docs/language/meta-arguments/for_each.html), boucler sur la resource `azurerm_resource_group` pour créer 3 Resource Group. ([Rappel syntaxe `for_each`](../memo.md##meta-arguments))  
   La boucle prendra comme liste la variable locale `resource_group_names`.  
   Concaténer chaque valeur de la liste avec le `name` du Resource Group.  
     
   => Initialiser puis exécuter un plan afin d'observer les modifications. (Vous n'êtes pas obligé d'appliquer le plan)  
   Vous devriez obtenir un plan comme celui là : 
   <br/>
   
   ![for_each](../images/for_each.png)

<br/>

3) A l'aide du meta-argument [`count`](https://www.terraform.io/docs/language/meta-arguments/count.html), créer 3 Resource Group. ([Rappel syntaxe `count`](../memo.md##meta-arguments))   
   Concaténer l'index du count (`count.index`) avec le `name` du Resource Group.

   => Initialiser puis exécuter un plan afin d'observer les modifications. (Vous n'êtes pas obligé d'appliquer le plan)  
   Vous devriez obtenir un plan comme celui là  
   <br/>
   
   ![count](../images/count.png)

<br/>

4) Le meta-argument `count` permet de conditionner la création d'une ressource. (si count = 0, aucune ressource n'est créée).  
   Créer un Resource Group à condition qu'une variable locale `enable_create` est à `true`. (tips: `count = local.isActive ? 1 : 0`)

   => Initialiser puis exécuter un plan afin d'observer les modifications. (Vous n'êtes pas obligé d'appliquer le plan)  

5) Détruire les ressources si besoin.

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