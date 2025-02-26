# Autoscale the functions based on memory usage
resource "azurerm_monitor_autoscale_setting" "functions_autoscale" {
  name                = "FunctionsAutoscaleSetting"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  target_resource_id  = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = [dasd"clientalerts@client.com"]
    }
  }
}