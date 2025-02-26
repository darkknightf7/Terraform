resource "azurerm_resource_group" "resource_group" {
  name     = "client-forms-dev-rg"
  location = var.location
}