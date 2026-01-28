variable "resource_group_name" { type = string }
variable "location" { type = string, default = "eastus" }
variable "tags" { type = map(string), default = {} }

variable "environment" { type = string } # dev/prod

variable "acr_name" { type = string }
variable "acr_sku"  { type = string, default = "Basic" }

variable "plan_name" { type = string }
variable "plan_sku"  { type = string, default = "P1v3" }

variable "app_name" { type = string }

variable "container_image" { type = string } # e.g. "myapi"
variable "container_tag" { type = string }   # e.g. "1.0.0"
variable "container_port" { type = number, default = 8000 }
