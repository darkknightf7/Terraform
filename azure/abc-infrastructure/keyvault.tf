######################Azure Key Vault###########################

data "azurerm_key_vault_secret" "Redis_Connection" {
  name         = "RedisConnection"
  key_vault_id = azurerm_key_vault.az2_client_prod_cust_kv.id
}


resource "azurerm_key_vault" "az2_client_prod_cust_kv" {
  name                            = "az2-client-prod-cust-kv"
  location                        = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name             = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  enabled_for_disk_encryption     = true
  tenant_id                       = "$tenant_ID"
  purge_protection_enabled        = true
  enabled_for_template_deployment = true
  sku_name                        = "standard"

  #network_acls {
  #  default_action = "Deny"
  #  bypass         = "AzureServices"
  #  ip_rules       = ["IP_ADD"]
    #    virtual_network_subnet_ids = [data.azurerm_subnet.back_tier.id]
  #  virtual_network_subnet_ids = [azurerm_subnet.backend_subnet.id]
  #}

  tags = {
    Environment = "PROD"
  }
}
resource "azurerm_key_vault_access_policy" "kv_access_frontdoor" {
  key_vault_id = azurerm_key_vault.az2_client_prod_cust_kv.id
  tenant_id    = "tenant_ID"
  object_id    = "Object_ID"

  certificate_permissions = [
    "Get",
    "List"
  ]
  key_permissions = [
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]
}
resource "azurerm_key_vault_access_policy" "lm_access_frontdoor" {
  key_vault_id = azurerm_key_vault.az2_client_prod_cust_kv.id
  tenant_id    = "tenant_ID"
  object_id    = "Object_ID"

  certificate_permissions = [
    "Get",
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]
  key_permissions = [
    "Get",
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Get",
    "Backup",
    "Delete",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]
}
