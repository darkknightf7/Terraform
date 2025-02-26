resource "azurerm_mssql_server" "mssql_server" {
  name                         = "client-dev-forms-mssql-server"
  resource_group_name          = var.rg
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "administartor"
  administrator_login_password = "administrator_login_passwordword"
}


resource "azurerm_mssql_database" "mssql_database" {
  name           = "client-dev-forms-db"
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 5
  read_scale     = true
  sku_name       = "S0"
  #zone_redundant = true
  
  tags = {
    enivornment = var.environment
  }

}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "client-dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
}


resource "azurerm_subnet" "sql_subnet" {
  name                                           = "client-dev-sql-subnet"
  resource_group_name                            = var.rg
  virtual_network_name                           = var.vnet
  address_prefixes                               = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}


resource "azurerm_subnet" "app_subnet" {
  name                                           = "client-dev-app-subnet"
  resource_group_name                            = var.rg
  virtual_network_name                           = var.vnet
  address_prefixes                               = ["10.0.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.KeyVault", "Microsoft.ServiceBus"]
  delegation {
    name = "app-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


#resource "azurerm_private_endpoint" "sqlprivateendpoint" {
#  name                = "client-dev-sql-private-endpoint"
#  location            = var.location
#  resource_group_name = var.rg
#  subnet_id           = azurerm_subnet.sql_subnet.id

#  private_service_connection {
#    name                           = "client-dev-privateserviceconnection"
##    private_connection_resource_id = azurerm_mssql_server.sqlsvr.id
##  subresource_names              = [ "sqlServer" ]
 #   is_manual_connection           = false
 # }
#}
#} 