variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "plan_name" { type = string }
variable "plan_sku" {
  type    = string
  default = "P1v3"
}

variable "app_name" { type = string }
variable "slot_name" { type = string, default = "staging" }

variable "container_registry_login_server" { type = string } # e.g. xxx.azurecr.io
variable "acr_id" { type = string }

variable "container_image" { type = string } # e.g. myapi
variable "container_tag"   { type = string } # e.g. 1.2.3 or sha
variable "container_port"  { type = number, default = 8000 }

variable "health_check_path" { type = string, default = "/health" }

variable "app_settings"      { type = map(string), default = {} }
variable "slot_app_settings" { type = map(string), default = {} }

variable "tags" { type = map(string), default = {} }
