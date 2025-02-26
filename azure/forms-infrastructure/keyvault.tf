resource "azurerm_key_vault" "key_vault" {
  name                        = "client-dev-key-vault"
  location                    = var.location
  resource_group_name         = var.rg
  enabled_for_disk_encryption = true
  tenant_id                   = "$tenantid"
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["ID"]
    virtual_network_subnet_ids = [azurerm_subnet.app_subnet.id]
  }
} 

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id            = azurerm_key_vault.key_vault.id
  certificate_permissions = []
  key_permissions         = []
  storage_permissions     = []
  object_id               = "object_id"
  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "recover",
    "backup",
    "restore",
    "purge",
  ]
  tenant_id = "tenant_id"
}
