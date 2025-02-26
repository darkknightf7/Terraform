resource "azurerm_subnet" "backend_subnet" {
  name                                           = "backend-subnet"
  resource_group_name                            = var.network_rg
  virtual_network_name                           = var.network_vnet
  address_prefixes                               = [var.network_subnet_ip4]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.KeyVault", "Microsoft.AzureCosmosDB"]
}
resource "azurerm_subnet" "apim_subnet" {
  name                                           = "apim-subnet"
  resource_group_name                            = var.network_rg
  virtual_network_name                           = var.network_vnet
  address_prefixes                               = [var.network_subnet_ip5]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.Web"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = var.network_rg
  virtual_network_name = var.network_vnet
  address_prefixes     = [var.network_subnet_ip6]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.ServiceBus","Microsoft.AzureCosmosDB"]
  delegation {
    name = "app-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurerm_subnet" "function_subnet" {
  name                 = "function-subnet"
  resource_group_name  = var.network_rg
  virtual_network_name = var.network_vnet
  address_prefixes     = [var.network_subnet_ip7]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.ServiceBus","Microsoft.AzureCosmosDB"]
  delegation {
    name = "app-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
