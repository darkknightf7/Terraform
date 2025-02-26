############################API MANAGEMENT SERVICE######################################
resource "azurerm_api_management" "az2_clienty_prod" {
  name                = "az2-clienty-prod"
  location            = azurerm_resource_group.az2_clienty_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_clienty_prod_customlayer_rsg.name
  publisher_name      = "client Group"
  publisher_email     = "itintegrationsservices@client.com"

  sku_name             = "Premium_1"
  virtual_network_type = "External"
  tags = {
    Environment = "PROD"
  }

  virtual_network_configuration {
    #    subnet_id  = data.azurerm_subnet.back_tier.id
    subnet_id = azurerm_subnet.apim_subnet.id
  }
}
