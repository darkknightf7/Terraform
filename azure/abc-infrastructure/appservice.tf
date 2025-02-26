resource "azurerm_app_service_plan" "az2_client_prod_frontend_apps_plan" {
  name                = "az2-client-prod-frontend-asp"
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  zone_redundant      = true
  kind                = "Linux"
  reserved            = true

  tags = {
    Environment = "PROD"
  }

  sku {
    tier     = "PremiumV3"
    size     = "P1v3"
    capacity = 6
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "appservice-vnet-connection" {
  app_service_id = azurerm_app_service.az2_client_prod_frontend_apps.id
  subnet_id      = azurerm_subnet.app_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "appservice-slot-vnet-connection" {
  app_service_id = azurerm_app_service.az2_client_prod_frontend_apps.id
  slot_name      = azurerm_app_service_slot.az2_client_prod_frontend_apps_staging_slot.name
  subnet_id      = azurerm_subnet.app_subnet.id
}


resource "azurerm_app_service" "az2_client_prod_frontend_apps" {
  name                = "az2-client-prod-frontend-apps"
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id = azurerm_app_service_plan.az2_client_prod_frontend_apps_plan.id
  https_only          = true

  site_config {
    linux_fx_version = "NODE|14-lts"
    ftps_state       = "FtpsOnly"
    always_on        = "true"
    http2_enabled    = "true"
    app_command_line = "npm run start"
    ip_restriction {
      ip_address = "IP Address"
      name       = "Restrict access to VPN"
      priority   = 400
    }
  }

  app_settings = {
    "API_BASE"                          = var.API_BASE
    "CYBERSOURCE_FRAME"                 = var.CYBERSOURCE_FRAME
    "DEV_API_URL"                       = var.DEV_API_URL
    "NEXT_PUBLIC_client_VERSION"          = var.NEXT_PUBLIC_client_VERSION
    "NEXT_PUBLIC_AZURE_B2C_TENANT_NAME" = var.AADB2C_TENANT_NAME
    "NEXT_PUBLIC_IMAGE_DOMAIN"          = trimsuffix(trimprefix(var.ASSETS_BASE_URL, "https://"), "/")
    "NODE_ENV"                          = "production"
    "SCM_COMMAND_IDLE_TIMEOUT"          = var.SCM_COMMAND_IDLE_TIMEOUT
    "APPINSIGHTS_INSTRUMENTATIONKEY"                    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"               = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"               = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION"        = "~3"
    "DiagnosticServices_EXTENSION_VERSION"              = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"           = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"                = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions"   = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"             = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"       = "disabled"
  }

  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_app_service_slot" "az2_client_prod_frontend_apps_staging_slot" {
  name                = "staging"
  app_service_name    = azurerm_app_service.az2_client_prod_frontend_apps.name
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id = azurerm_app_service_plan.az2_client_prod_frontend_apps_plan.id
  https_only          = true

  site_config {
    linux_fx_version = "NODE|14-lts"
    ftps_state       = "FtpsOnly"
    always_on        = "true"
    http2_enabled    = "true"
    app_command_line = "npm run start"
    ip_restriction {
      ip_address = "$IP Address"
      name       = "Restrict access to VPN"
      priority   = 400
    }
  }

  app_settings = {
    "API_BASE"                          = var.API_BASE
    "CYBERSOURCE_FRAME"                 = var.CYBERSOURCE_FRAME
    "DEV_API_URL"                       = var.DEV_API_URL
    "NEXT_PUBLIC_client_VERSION"          = var.NEXT_PUBLIC_client_VERSION
    "NEXT_PUBLIC_AZURE_B2C_TENANT_NAME" = var.AADB2C_TENANT_NAME
    "NEXT_PUBLIC_IMAGE_DOMAIN"          = trimsuffix(trimprefix(var.ASSETS_BASE_URL, "https://"), "/")
    "NODE_ENV"                          = "production"
    "SCM_COMMAND_IDLE_TIMEOUT"          = var.SCM_COMMAND_IDLE_TIMEOUT
    "APPINSIGHTS_INSTRUMENTATIONKEY"                    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"               = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"               = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION"        = "~3"
    "DiagnosticServices_EXTENSION_VERSION"              = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"           = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"                = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions"   = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"             = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"       = "disabled"
  }
  
  tags = {
    Environment = "PROD"
  }
}
