# NB : le provider est instancié une seule fois ici dans le fichier de configuration principal
provider "azurerm" {
    features {}
}

# TODO: J'instancie le module 'resource-group'

module "rg" {
    source = ...
    ...
}


# TODO: Je décris mes outputs

output "resource_group_id" {
    value = ...
}
   
output "resource_group_name" {
    value = ...
}  