############################Cosmos DB################################

resource "azurerm_cosmosdb_account" "az2_client_prod_customlayer_csdb" {
  name                              = "az2-client-prod-customlayer-csdb"
  location                          = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name               = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  offer_type                        = "Standard"
  kind                              = "GlobalDocumentDB"
  enable_multiple_write_locations   = false
  ip_range_filter                   = "$IP_Addresses"
  is_virtual_network_filter_enabled = true
  
  tags = {
    Environment = "PROD"
  }

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    failover_priority = 0
    location          = "eastus2"
    zone_redundant    = true
  }
  geo_location {
    failover_priority = 1
    location          = "centralus"
  }
  virtual_network_rule {
    #    id                                   = data.azurerm_subnet.back_tier.id
    id                                   = azurerm_subnet.backend_subnet.id
    ignore_missing_vnet_service_endpoint = false
  }
  virtual_network_rule {
    #    id                                   = data.azurerm_subnet.back_tier.id
    id                                   = azurerm_subnet.function_subnet.id
    ignore_missing_vnet_service_endpoint = false
  }
  virtual_network_rule {
    #    id                                   = data.azurerm_subnet.back_tier.id
    id                                   = azurerm_subnet.app_subnet.id
    ignore_missing_vnet_service_endpoint = false
  }
}

#resource "azurerm_private_endpoint" "cosmosprivateendpoint" {
#  name                = "${lower(var.client)}-cosmos-private-endpoint"
#  location            = "East US 2"
#  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
#  subnet_id           = data.azurerm_subnet.back_tier.id

#  private_service_connection {
#    name                           = "${lower(var.client)}-privateserviceconnection"
#    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
#    subresource_names              = ["Sql"]
#    is_manual_connection           = false
#  }
#}
