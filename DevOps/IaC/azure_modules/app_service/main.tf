terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.90.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_service_plan" "this" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.plan_sku

  tags = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "${var.container_image}:${var.container_tag}"
      docker_registry_url = "https://${var.container_registry_login_server}"
    }

    health_check_path = var.health_check_path
  }

  app_settings = merge({
    WEBSITES_PORT                     = tostring(var.container_port)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    # Recommended: disable app restarts on slot swap if you want fast swap behavior tuned
  }, var.app_settings)

  tags = var.tags
}

# Slot for staged deployments (rollback via swap)
resource "azurerm_linux_web_app_slot" "staging" {
  name           = var.slot_name
  app_service_id = azurerm_linux_web_app.this.id
  https_only     = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "${var.container_image}:${var.container_tag}"
      docker_registry_url = "https://${var.container_registry_login_server}"
    }

    health_check_path = var.health_check_path
  }

  app_settings = merge({
    WEBSITES_PORT                       = tostring(var.container_port)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }, var.slot_app_settings)

  tags = var.tags
}

# Grant WebApp MI pull permission to ACR
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "slot_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app_slot.staging.identity[0].principal_id
}

output "webapp_default_hostname" { value = azurerm_linux_web_app.this.default_hostname }
output "slot_hostname"           { value = azurerm_linux_web_app_slot.staging.default_hostname }
output "webapp_principal_id"     { value = azurerm_linux_web_app.this.identity[0].principal_id }
output "slot_principal_id"       { value = azurerm_linux_web_app_slot.staging.identity[0].principal_id }
