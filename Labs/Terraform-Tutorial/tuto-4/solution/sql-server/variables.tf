variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "sql_server_name" {
  type = string
  description = "SQL Server Name."
}

variable "admin_login" {
  type = string
  description = "SQL Server administrator login."
}

variable "admin_password" {
  type      = string
  sensitive = true
  description = "SQL Server administrator password."
}

variable "database_name" {
  type = string
  description = "SQL Server database name."
}