# NB : le provider est instancié une seule fois ici dans le fichier de configuration principal
provider "azurerm" {
    features {}
}


module "rg" {
  source = "../../tuto-2/my-work/resource-group"
  resource_group_name = ...
}


# TODO: J'instancie le module 'app-service'




# TODO: Je décris mes outputs
