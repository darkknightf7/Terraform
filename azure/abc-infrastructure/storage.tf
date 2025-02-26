resource "azurerm_storage_account" "az2clientprodappstg" {
  name                     = "az2clientprodappstg"
  resource_group_name      = "az2-client-prod-sharedsvcs-rsg"
  location                 = "East US 2"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_blob_public_access = "true"

  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_storage_container" "container_email" {
  name                  = "email"
  storage_account_name  = azurerm_storage_account.az2clientprodappstg.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "container_media" {
  name                  = "media"
  storage_account_name  = azurerm_storage_account.az2clientprodappstg.name
  container_access_type = "blob"
}

resource "azurerm_storage_account" "az2clientprodclstg" {
  name                     = "az2clientprodclstg"
  resource_group_name      = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  location                 = "East US 2"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_blob_public_access = "true"

  tags = {
    environment = "prod"
  }
}
