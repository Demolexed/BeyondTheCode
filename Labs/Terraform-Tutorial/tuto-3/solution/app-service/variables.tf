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