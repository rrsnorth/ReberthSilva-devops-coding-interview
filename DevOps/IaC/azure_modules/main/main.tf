terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.90.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "acr" {
  source              = "./modules/acr"
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = var.tags
}

module "api" {
  source  = "./modules/app_service_api"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  plan_name = var.plan_name
  plan_sku  = var.plan_sku

  app_name  = var.app_name
  slot_name = "staging"

  acr_id                         = module.acr.id
  container_registry_login_server = module.acr.login_server
  container_image                = var.container_image
  container_tag                  = var.container_tag
  container_port                 = var.container_port

  app_settings = {
    APP_ENV = var.environment
  }

  slot_app_settings = {
    APP_ENV = "staging"
  }

  tags = var.tags
}

output "prod_url" { value = "https://${module.api.webapp_default_hostname}" }
output "staging_url" { value = "https://${module.api.slot_hostname}" }
