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