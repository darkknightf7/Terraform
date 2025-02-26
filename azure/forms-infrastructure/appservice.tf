resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "client-forms-appserviceplan"
  location            = var.location
  resource_group_name = var.rg

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "client-forms-app-service"
  location            = var.location
  resource_group_name = var.rg
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    always_on                   = "true"
    dotnet_framework_version    = "v4.0"
    ftps_state                  = "FtpsOnly"
    managed_pipeline_mode       = "Integrated"
    websockets_enabled          = "false"
    use_32_bit_worker_process   = "false"
    scm_use_main_ip_restriction = "true"
    default_documents = [
      "hostingstart.html",
    ]


  }

  app_settings = {
    "SOME_KEY" = "some-value"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
