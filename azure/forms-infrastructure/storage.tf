resource "azurerm_storage_account" "terraform_storage_account" {
  name                     = "clienttfstate"
  resource_group_name      = var.rg
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  access_tier = "Hot"
  account_replication_type = "ZRS"
  allow_blob_public_access = "true"

  lifecycle {
    prevent_destroy = true
  } 

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "client-forms-terraform-container" {
  name = "client-tfstate"
  storage_account_name = azurerm_storage_account.terraform_storage_account.name
  container_access_type = "private"
}