variable "name" { type = string } # must be globally unique, 5-50 alnum
variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "sku" {
  type    = string
  default = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be Basic|Standard|Premium"
  }
}

variable "admin_enabled" { type = bool, default = false }
variable "tags" { type = map(string), default = {} }
