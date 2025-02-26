### Action Goups ###
# client Action Group
resource "azurerm_monitor_action_group" "email_alerts" {
  name                = "email_alerts"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  short_name          = "email"

  email_receiver {
    name          = "sendtoclient"
    email_address = "$email"
  }
}

# client Action Group
resource "azurerm_monitor_action_group" "client_email_alerts" {
  name                = "client_email_alerts"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  short_name          = "clientemail"

  email_receiver {
    name          = "sendto"
    email_address = "clientalerts@client.com"
  }
}

### Alerts ###
### Custom Layer ###
# Custom layer app service plan memory greater than 80% alert. Severity is warning (2).
resource "azurerm_monitor_metric_alert" "customlayer_asp_memory" {
  name                = "customlayer-asp-memory-alert"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  scopes              = [azurerm_app_service_plan.az2_client_prod_customlayer-asp.id]
  description         = "Action will be triggered when Memory percentage greater than 80. Sev Warn"
  severity            = 2

  criteria {
    metric_name      = "MemoryPercentage"
    metric_namespace = "Microsoft.Web/serverfarms"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
  action {
    action_group_id = azurerm_monitor_action_group.client_email_alerts.id
  }
}

# Custom layer app service plan memory greater than 85% alert. Severity is critical (0).
resource "azurerm_monitor_metric_alert" "customlayer_asp_memory_crit" {
  name                = "customlayer-asp-memory-alert-crit"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  scopes              = [azurerm_app_service_plan.az2_client_prod_customlayer-asp.id]
  description         = "Action will be triggered when Memory percentage greater than 85. Sev Crit"
  severity            = 0

  criteria {
    metric_name      = "MemoryPercentage"
    metric_namespace = "Microsoft.Web/serverfarms"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
  action {
    action_group_id = azurerm_monitor_action_group.client_email_alerts.id
  }
}

# Custom layer app service plan CPU greater than 85% alert. Sererity is Warning (2).
resource "azurerm_monitor_metric_alert" "customlayer_asp_cpu" {
  name                = "customlayer-asp-cpu-alert"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  scopes              = [azurerm_app_service_plan.az2_client_prod_customlayer-asp.id]
  description         = "Action will be triggered when Memory percentage greater than 85. Sev WARN."
  severity            = 2

  criteria {
    metric_name      = "CpuPercentage"
    metric_namespace = "Microsoft.Web/serverfarms"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
  action {
    action_group_id = azurerm_monitor_action_group.client_email_alerts.id
  }
}

# Custom layer app service plan CPU greater than 90% alert. Sererity is Critical (2).
resource "azurerm_monitor_metric_alert" "customlayer_asp_cpu_crit" {
  name                = "customlayer-asp-cpu-alert-crit"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  scopes              = [azurerm_app_service_plan.az2_client_prod_customlayer-asp.id]
  description         = "Action will be triggered when Memory percentage greater than 90. Sev CRIT."
  severity            = 0

  criteria {
    metric_name      = "CpuPercentage"
    metric_namespace = "Microsoft.Web/serverfarms"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
  action {
    action_group_id = azurerm_monitor_action_group.client_email_alerts.id
  }
}

# Custom layer app service plan HTTP Queue Length greater than 4 alert
resource "azurerm_monitor_metric_alert" "customlayer_asp_httpqueue" {
  name                = "customlayer-asp-httpqueue-alert"
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  scopes              = [azurerm_app_service_plan.az2_client_prod_customlayer-asp.id]
  description         = "Action will be triggered when HTTP Queue Length is greater than 4."

  criteria {
    metric_name      = "HttpQueueLength"
    metric_namespace = "Microsoft.Web/serverfarms"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 6
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
  action {
    action_group_id = azurerm_monitor_action_group.client_email_alerts.id
  }
}