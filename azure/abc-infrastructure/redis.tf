#########################Redis Cache#################################
resource "azurerm_redis_cache" "az2_client_prd_customlayer_redis" {
  name                = "az2-client-prd-customlayer-redis"
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  capacity            = 1
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  shard_count         = "1"
  subnet_id           = azurerm_subnet.backend_subnet.id
  redis_configuration {
  }
  tags = {
    Environment = "PROD"
  }
}
