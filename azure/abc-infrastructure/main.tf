terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.92.0"
    }
  }
}
terraform {
  backend "azurerm" {
    resource_group_name  = "az2-client-prod-sharedsvcs-rsg"
    storage_account_name = "$storage_name"
    container_name       = "terraform-state"
    key                  = "statefile/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


###Data Block####
data "azurerm_log_analytics_workspace" "az2_client_prod_log" {
  name                = "az2-client-prod-log"
  resource_group_name = "az2-client-prod-sharedsvcs-rsg"
}

output "log_analytics_workspace_id" {
  value = data.azurerm_log_analytics_workspace.az2_client_prod_log.workspace_id
}

#data "azurerm_subnet" "back_tier" {
#name = "back-tier"
#virtual_network_name = "az2-client-prod-vnet"
#resource_group_name = "az2-client-prod-networking-rsg"
#}
