variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) Virtual Network name."
}

variable "address_spaces" {
  type        = list(string)
  description = "List of address prefix."
}

variable "subnets" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "List of Subnets."
}