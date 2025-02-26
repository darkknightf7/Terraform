resource "azurerm_frontdoor" "az2_client_prod_frontdoor" {
  name                                         = "az2-prod-frontdoor"
  resource_group_name                          = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  enforce_backend_pools_certificate_name_check = false
  
  tags = {
    Environment = "PROD"
  }

#### Routing Rules ####
#### Route images to the image backend. CDN Enabled ####
  routing_rule {
    name               = "clientRoutingRuleProdImages"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["HelloclientProdImages"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "az2-client-prod-backend-images"
      cache_enabled = true
    }
  }
#### Route prod requests to the app backend ####
  routing_rule {
    name               = "clientRoutingRuleProd"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["HelloclientProdDefault", "HelloclientProdTest", "HelloclientProd"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "az2-client-prod-backend"
      cache_enabled = false
    }
  }
#### Redirect the root domain helloclient.com to www.helloclient.com ####
    routing_rule {
    name               = "clientRoutingRuleProdRoot"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["HelloclientProdRoot"]
    redirect_configuration {
      custom_host       = "www.helloclient.com"
      redirect_protocol = "MatchRequest"
      redirect_type     = "PermanentRedirect"
    }
  }
#### LB and Prob settings ####
  backend_pool_load_balancing {
    name = "clientLoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name     = "clientHealthProbeSetting1"
    protocol = "Https"
  }
#### Backend Pools ####
#### App backend pool ####
  backend_pool {
    name = "az2-client-prod-backend"
    backend {
      enabled     = true
      host_header = "az2-client-prod-frontend-apps.azurewebsites.net"
      address     = "az2-client-prod-frontend-apps.azurewebsites.net"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "clientLoadBalancingSettings1"
    health_probe_name   = "clientHealthProbeSetting1"
  }
#### Images backend pool ####
  backend_pool {
    name = "az2-client-prod-backend-images"
    backend {
      enabled     = true
      host_header = "az2clientprodappstg.blob.core.windows.net"
      address     = "az2clientprodappstg.blob.core.windows.net"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "clientLoadBalancingSettings1"
    health_probe_name   = "clientHealthProbeSetting1"
  }
#### DR Backends. Uncomment when DR is ready. ####
  #  backend_pool {
  #    name = "az4-client-prod-backend-images"
  #    backend {
  #      enabled     = false
  #      host_header = "az4clientprodappstg.blob.core.windows.net/"
  #      address     = "az4clientprodappstg.blob.core.windows.net"
  #      http_port   = 80
  #      https_port  = 443
  #    }
  #
  #    load_balancing_name = "clientLoadBalancingSettings1"
  #    health_probe_name   = "clientHealthProbeSetting1"
  #  }

 #    backend_pool {
 #      name = "az4-client-prod-backend"
 #      backend {
 #        enabled = false
 #        host_header = "az4-client-prod-frontend-apps.azurewebsites.net"
#         address     = "az4-client-prod-frontend-apps.azurewebsites.net"
#         http_port   = 80
#         https_port  = 443
#       }

#        load_balancing_name = "clientLoadBalancingSettings1"
#        health_probe_name   = "clientHealthProbeSetting1"
#      }
#### Frontend endpoints ####
#### Default endpoint. Required for Azure Frontdoor ####
  frontend_endpoint {
    name                                    = "HelloclientProdDefault"
    host_name                               = "az2-client-prod-frontdoor.azurefd.net"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.az2_client_prod_cust_fdwaf.id
  }
#### prdtest endpoint. Can be removed when the prdtest.helloclient.com cname is removed in the DNS. ####
  frontend_endpoint {
    name                                    = "HelloclientProdTest"
    host_name                               = "prdtest.helloclient.com"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.az2_client_prod_cust_fdwaf.id
  }
#### Images endpoint. ####
  frontend_endpoint {
    name                                    = "HelloclientProdImages"
    host_name                               = "clientimages.helloclient.com"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.az2_client_prod_cust_fdwaf.id
  }
#### Main www.helloclient.com endpoint. ####
  frontend_endpoint {
    name                                    = "HelloclientProd"
    host_name                               = "www.helloclient.com"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.az2_client_prod_cust_fdwaf.id
  }
#### Root domain helloclient.com endpoint. Redirects to www.helloclient.com. ####
  frontend_endpoint {
    name                                    = "HelloclientProdRoot"
    host_name                               = "helloclient.com"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.az2_client_prod_cust_fdwaf.id
  }
}
#### Custom https & cert configurations. ####
#### For prdtest. Can be removed when the prdtest.helloclient.com cname is removed in the DNS. ####
resource "azurerm_frontdoor_custom_https_configuration" "prdtest_helloclient_com" {
  frontend_endpoint_id              = azurerm_frontdoor.az2_client_prod_frontdoor.frontend_endpoints["HelloclientProdTest"]
  custom_https_provisioning_enabled = true

  custom_https_configuration {
    certificate_source                      = "AzureKeyVault"
    azure_key_vault_certificate_secret_name = "wildcard-helloclient-com"
    azure_key_vault_certificate_vault_id    = azurerm_key_vault.az2_client_prod_cust_kv.id
  }
}
#### Main www.helloclient.com. ####
resource "azurerm_frontdoor_custom_https_configuration" "www_helloclient_com" {
  frontend_endpoint_id              = azurerm_frontdoor.az2_client_prod_frontdoor.frontend_endpoints["HelloclientProd"]
  custom_https_provisioning_enabled = true

  custom_https_configuration {
    certificate_source                      = "AzureKeyVault"
    azure_key_vault_certificate_secret_name = "wildcard-helloclient-com"
    azure_key_vault_certificate_vault_id    = azurerm_key_vault.az2_client_prod_cust_kv.id
  }
}
#### Root helloclient.com. ####
resource "azurerm_frontdoor_custom_https_configuration" "helloclient_com" {
  frontend_endpoint_id              = azurerm_frontdoor.az2_client_prod_frontdoor.frontend_endpoints["HelloclientProdRoot"]
  custom_https_provisioning_enabled = true

  custom_https_configuration {
    certificate_source                      = "AzureKeyVault"
    azure_key_vault_certificate_secret_name = "wildcard-helloclient-com"
    azure_key_vault_certificate_vault_id    = azurerm_key_vault.az2_client_prod_cust_kv.id
  }
}
#### Images. ####
resource "azurerm_frontdoor_custom_https_configuration" "clientimages_helloclient_com" {
  frontend_endpoint_id              = azurerm_frontdoor.az2_client_prod_frontdoor.frontend_endpoints["HelloclientProdImages"]
  custom_https_provisioning_enabled = true

  custom_https_configuration {
    certificate_source                      = "AzureKeyVault"
    azure_key_vault_certificate_secret_name = "wildcard-helloclient-com"
    azure_key_vault_certificate_vault_id    = azurerm_key_vault.az2_client_prod_cust_kv.id
  }
}
#### WAF Policys. #####
resource "azurerm_frontdoor_firewall_policy" "az2_client_prod_cust_fdwaf" {
  name                              = "az2prodwaf"
  resource_group_name               = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  enabled                           = true
  mode                              = "Detection"
  custom_block_response_status_code = 403
  custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
#      exclusion {
#        match_variable = "QueryStringArgNames"
#        operator       = "Contains"
#        selector       = "clientimages.helloclient.com"
#      }
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
}