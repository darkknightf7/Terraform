terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "subscription_id"
}

terraform {
  backend "azurerm" {
    subscription_id       = "subscription_id"
    resource_group_name   = "client-forms-dev-rg"
    storage_account_name  = "clientformstfstate"
    container_name        = "clientforms-tfstate"
    key                   = "Terraform/dev/terraform.tfstate"
  }
}

#data "azurerm_key_vault_secret" "sql-admin-password" {
#  name         = "sql-administrator-login-password"
##  key_vault_id = data.azurerm_key_vault.client-dev-key_vault.id
#}