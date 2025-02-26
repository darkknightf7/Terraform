resource "azurerm_application_insights" "az2_client_prod_customlayer_ai" {
  name                = "az2-client-prod-customlayer-ai"
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  application_type    = "web"
  disable_ip_masking  = true
  workspace_id        = data.azurerm_log_analytics_workspace.az2_client_prod_log.id
  tags = {
    Environment = "PROD"
  }
}
