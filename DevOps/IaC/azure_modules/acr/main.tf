terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.90.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = var.tags
}

output "login_server" { value = azurerm_container_registry.this.login_server }
output "id"           { value = azurerm_container_registry.this.id }
