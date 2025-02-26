resource "azurerm_app_service_plan" "az2_client_prod_customlayer-asp" {
  name                = "az2-client-prod-customlayer-asp"
  location            = azurerm_resource_group.az2_client_prod_customlayer_rsg.location
  resource_group_name = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  tags = {
    Environment = "PROD"
  }
  sku {
    tier = "PremiumV3"
    size = "P1v3"
    capacity = 2
  }
}

resource "azurerm_function_app" "az2_client_prod_customer_func" {
  name                       = "az2-client-prod-customer-func"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      name        = "APIM-Subnet"
      virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
#    "client_dev_rooturl"           = var.client_BASE_URL
    "client_prod_rooturl"           = var.client_BASE_URL
    "client_forgot_password"        = "${var.client_BASE_URL}passwordsetup?token="
    "client_welcome_url"            = "${var.client_BASE_URL}welcome?token="
    "clientBaseURL"                 = var.client_BASE_URL
    "assetBaseURL"                = var.ASSETS_BASE_URL
# AzureWebJobsDashboard was added manually in Azure and backed in. Check later.
    "AzureWebJobsDashboard"       = "Azure_storage_string"
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "BaseURL"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/Customers/"
    "CAB"                         = var.CAB
    "Customer Type"               = var.CUSTOMER_TYPE
    "DefaultPrescriptionDuration" = var.DEFAULT_RX_DURATION
    "DOB"                         = var.DOB
    "Patient Address Book"        = var.PATIENT_ADDRESS_BOOK
    "Patient PG"                  = var.PATIENT_PG
    "Sign Up Date"                = var.SIGN_UP_DATE
    "Sign Up Location"            = var.SIGN_UP_LOCATION
    "Sign Up Practice"            = var.SIGN_UP_PRACTICE
    "IsCompleted"                 = var.IS_COMPLETE
    "Location"                    = var.LOCATION
    "emailDisplayName"            = var.EMAIL_SENDER_NAME
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "grant_type"                  = "client_credentials"
    "host"                        = var.EMAIL_SMTP_HOST
    "HostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "resource"                    = var.OAUTH_RESOURCE
    "ropc_client_id"              = var.AADB2C_ROPC_CLIENT_ID
    "ropc_grant_type"             = "password"
    "ropc_response_type"          = "token id_token"
    "ropc_scope"                  = "openid ${var.AADB2C_ROPC_CLIENT_ID}"
    "ropc_URL"                    = "https://${var.AADB2C_TENANT_NAME}.b2clogin.com/${var.AADB2C_TENANT_NAME}.onmicrosoft.com/${var.ROPC_USER_FLOW}/oauth2/v2.0/token"
    "D365_B2C_DataAreaID"         = var.B2C_DATAAREA_ID
    "D365_B2C_ProviderID"         = var.B2C_PROVIDER_ID
    "signInType"                  = "emailAddress"
    "siteUrlPH"                   = "{{siteURL}}"
    "StorageAccountName"          = "az2clientprodclstg"
    "templateFolder"              = "templates/"
    "tokenPH"                     = "{{token}}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "WEBSITE_CONTENTSHARE"        = "staginge704"
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "connectionstring"
  }
  tags = {
    Enviornment = "PROD"
  }
}

resource "azurerm_function_app_slot" "az2_client_prod_customer_func_slot" {
  name                       = "staging"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  function_app_name          = azurerm_function_app.az2_client_prod_customer_func.name
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
#    "client_dev_rooturl"           = var.client_BASE_URL
    "client_prod_rooturl"           = var.client_BASE_URL
    "client_forgot_password"        = "${var.client_BASE_URL}passwordsetup?token="
    "client_welcome_url"            = "${var.client_BASE_URL}welcome?token="
    "clientBaseURL"                 = var.client_BASE_URL
    "assetBaseURL"                = var.ASSETS_BASE_URL
    "Avalara_hostURL"             = var.AVALARA_HOST_URL
    "Avalara_token"               = var.AVALARA_TOKEN
    "AvalaraApi"                  = var.AVALARA_API
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "BaseURL"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/Customers/"
    "CAB"                         = var.CAB
    "Customer Type"               = var.CUSTOMER_TYPE
    "DefaultPrescriptionDuration" = var.DEFAULT_RX_DURATION
    "DOB"                         = var.DOB
    "Patient Address Book"        = var.PATIENT_ADDRESS_BOOK
    "Patient PG"                  = var.PATIENT_PG
    "Sign Up Date"                = var.SIGN_UP_DATE
    "Sign Up Location"            = var.SIGN_UP_LOCATION
    "Sign Up Practice"            = var.SIGN_UP_PRACTICE
    "IsCompleted"                 = var.IS_COMPLETE
    "Location"                    = var.LOCATION
    "emailDisplayName"            = var.EMAIL_SENDER_NAME
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "grant_type"                  = "client_credentials"
    "host"                        = var.EMAIL_SMTP_HOST
    "HostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "resource"                    = var.OAUTH_RESOURCE
    "ropc_client_id"              = var.AADB2C_ROPC_CLIENT_ID
    "ropc_grant_type"             = "password"
    "ropc_response_type"          = "token id_token"
    "ropc_scope"                  = "openid ${var.AADB2C_ROPC_CLIENT_ID}"
    "ropc_URL"                    = "https://${var.AADB2C_TENANT_NAME}.b2clogin.com/${var.AADB2C_TENANT_NAME}.onmicrosoft.com/${var.ROPC_USER_FLOW}/oauth2/v2.0/token"
    "D365_B2C_DataAreaID"         = var.B2C_DATAAREA_ID
    "D365_B2C_ProviderID"         = var.B2C_PROVIDER_ID
    "signInType"                  = "emailAddress"
    "siteUrlPH"                   = "{{siteURL}}"
    "StorageAccountName"          = "az2clientprodclstg"
    "templateFolder"              = "templates/"
    "tokenPH"                     = "{{token}}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
  }
  tags = {
    Environment = "PROD"
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "customer-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_customer_func.id
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "customer-slot-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_customer_func.id
  slot_name      = azurerm_function_app_slot.az2_client_prod_customer_func_slot.name
  subnet_id      = azurerm_subnet.function_subnet.id
}



resource "azurerm_function_app" "az2_client_prod_prescription_func" {
  name                       = "az2-client-prod-prescription-func"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AddLineURL"                  = "client_AddProductListLines"
# AzureWebJobsDashboard & AzureWebJobsStorage were added manually in Azure and backed in. Check later.
    "AzureWebJobsDashboard"       = "connectionstring"
    "AzureWebJobsStorage"         = "connectionstring"
    "BaseAddress"                 = var.D365_RETAIL_BASE_URL
    "BaseURL"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/ProductLists"
    "CreateURL"                   = "client_CreateProductList"
    "DataAreaId"                  = var.B2C_DATAAREA_ID
    "DeleteURL"                   = "client_DeleteProductList"
    "getByAccountNumbers"         = "${var.D365_RETAIL_BASE_URL}/Commerce/Customers/GetByAccountNumbers?$skip=0&$top=100&api-version=7.1"
    "GetLineURL"                  = "client_GetProductListLines"
    "grant_type"                  = "client_credentials"
    "HostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "leftEyeIndicator"            = "Le"
    "leftUnitOfMeasure"           = "EA"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "RemoveLineURL"               = "client_RemoveProductListLines"
    "resource"                    = var.OAUTH_RESOURCE
    "rightEyeIndicator"           = "Ri"
    "rightUnitOfMeasure"          = "EA"
    "SearchURL"                   = "client_SearchProductList"
    "StorageAccountName"          = "az2clientprodclstorage"
    "UpdateLineURL"               = "client_UpdateProductListLines"
    "UpdateURL"                   = "client_UpdateProductList"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "connectionstring"
#    "WEBSITE_CONTENTSHARE"        = "staginge704"
    "WEBSITE_CONTENTSHARE"        = "staging11cd"
    "scm_type"                    = "VSTSRM"
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_function_app_slot" "az2_client_prod_prescription_func_slot" {
  name                       = "staging"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  function_app_name          = azurerm_function_app.az2_client_prod_prescription_func.name
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AddLineURL"                  = "client_AddProductListLines"
    "BaseAddress"                 = var.D365_RETAIL_BASE_URL
    "BaseURL"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/ProductLists"
    "CreateURL"                   = "client_CreateProductList"
    "DataAreaId"                  = var.B2C_DATAAREA_ID
    "DeleteURL"                   = "client_DeleteProductList"
    "getByAccountNumbers"         = "${var.D365_RETAIL_BASE_URL}/Commerce/Customers/GetByAccountNumbers?$skip=0&$top=100&api-version=7.1"
    "GetLineURL"                  = "client_GetProductListLines"
    "grant_type"                  = "client_credentials"
    "HostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "leftEyeIndicator"            = "Le"
    "leftUnitOfMeasure"           = "EA"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "RemoveLineURL"               = "client_RemoveProductListLines"
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "resource"                    = var.OAUTH_RESOURCE
    "rightEyeIndicator"           = "Ri"
    "rightUnitOfMeasure"          = "EA"
    "SearchURL"                   = "client_SearchProductList"
    "StorageAccountName"          = "az2clientprodclstorage"
    "UpdateLineURL"               = "client_UpdateProductListLines"
    "UpdateURL"                   = "client_UpdateProductList"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "prescription-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_prescription_func.id
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "prescription-slot-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_prescription_func.id
  slot_name      = azurerm_function_app_slot.az2_client_prod_prescription_func_slot.name
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_function_app" "az2_client_prod_product_func" {
  name                       = "az2-client-prod-product-func"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
    ip_restriction {
      name        = "function-Subnet"
     virtual_network_subnet_id = azurerm_subnet.function_subnet.id
      priority    = "13"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AuthUrl"                     = var.OAUTH_TOKEN_URI
# AzureWebJobsDashboard was added manually in Azure and backed in. Check later.
    "AzureWebJobsDashboard"       = "connection string"
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "CategoriesCall"              = "${var.D365_RETAIL_BASE_URL}/Commerce/Categories/GetCategories?$skip=0&$top=1000&api-version=7.1"
    "channelId"                   = var.CHANNEL_ID
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OUN"                         = var.OAUTH_OUN
    "ProductAttributeCall"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetAttributeValuesAsync?$skip=0&$top=100&api-version=7.1"
    "ProductByCategoriesCall"     = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/Search?$skip=0&$top=1000&api-version=7.1"
    "ProductByCategoriesCallNew"  = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ProductDimensionsCall"       = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "resource"                    = var.OAUTH_RESOURCE
    "restartURL"                  = var.FUNCTION_URL_PRODUCT_SYNC
    "StorageAccountName"          = "az2clientprodclstorage"
    "VarianrDimensionsCall"       = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetCustomVariantDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "variantIdsByMasterProduct"   = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetProductsVariantIds"
    "VariantsByMasterProductCall" = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/Search?$skip=0&$top=100&api-version=7.1"
    "VariantsByVariantIds"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetAllProducts?$skip=0&$top=1000&api-version=7.1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "connectionstring"
    "WEBSITE_CONTENTSHARE"       = "staging2c7b"
    "scm_type"                    = "VSTSRM"
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_function_app_slot" "az2_client_prod_product_func_slot" {
  name                       = "staging"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  function_app_name          = azurerm_function_app.az2_client_prod_product_func.name
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
    ip_restriction {
      name        = "function-Subnet"
     virtual_network_subnet_id = azurerm_subnet.function_subnet.id
      priority    = "13"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AuthUrl"                     = var.OAUTH_TOKEN_URI
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "CategoriesCall"              = "${var.D365_RETAIL_BASE_URL}/Commerce/Categories/GetCategories?$skip=0&$top=1000&api-version=7.1"
    "channelId"                   = var.CHANNEL_ID
    "isRelease"                   = "true"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OUN"                         = var.OAUTH_OUN
    "ProductAttributeCall"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetAttributeValuesAsync?$skip=0&$top=100&api-version=7.1"
    "ProductByCategoriesCall"     = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/Search?$skip=0&$top=1000&api-version=7.1"
    "ProductByCategoriesCallNew"  = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ProductDimensionsCall"       = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "resource"                    = var.OAUTH_RESOURCE
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "restartURL"                  = var.FUNCTION_URL_PRODUCT_SYNC
    "StorageAccountName"          = "az2clientprodclstorage"
    "VarianrDimensionsCall"       = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetCustomVariantDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "variantIdsByMasterProduct"   = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetProductsVariantIds"
    "VariantsByMasterProductCall" = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/Search?$skip=0&$top=100&api-version=7.1"
    "VariantsByVariantIds"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetAllProducts?$skip=0&$top=1000&api-version=7.1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "product-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_product_func.id
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "product-slot-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_product_func.id
  slot_name      = azurerm_function_app_slot.az2_client_prod_product_func_slot.name
  subnet_id      = azurerm_subnet.function_subnet.id
}



resource "azurerm_function_app" "az2_client_prod_salesorder_func" {
  name                       = "az2-client-prod-salesorder-func"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                = "1"
    "FUNCTIONS_EXTENSION_VERSION"             = "~3"
    "FUNCTIONS_WORKER_RUNTIME"                = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"                = "1"
    "client_GetSalesOrderPool"                   = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_GetSalesOrderPool"
    "client_SalesOrderExtended"                  = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersExtended?$skip=0&$top=100&api-version=7.1"
    "client_SalesOrderExtendedRefined"           = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_GetRefinedOrderHistory"
    "client_SalesOrderPoolUpdate"                = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SalesOrderPoolUpdate?api-version=7.1"
    "client_SearchOrderAsync"                    = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersAsync?$skip=0&$top=100&api-version=7.1"
    "clientBaseURL"                             = var.client_BASE_URL
    "assetBaseURL"                            = var.ASSETS_BASE_URL
# AzureWebJobsDashboard was added manually in Azure and backed in. Check later.
    "AzureWebJobsDashboard"       = var.connectionstring
    "AzureWebJobsStorage"                     = var.LOG_STORAGE_CONNECTION
    "BaseURL"                                 = "${var.D365_RETAIL_BASE_URL}/Commerce/"
    "CartApi"                                 = "${var.D365_RETAIL_BASE_URL}/Commerce/Carts"
    "Client_Id_POS"                           = var.POS_CLIENT_ID
    "CS_EncryptionKey"                        = "RsaOaep"
    "CS_format"                               = "JWT"
    "CS_Host"                                 = var.CYBERSOURCE_IS_PRODCTION ? "api.cybersource.com" : "apitest.cybersource.com"
    "CS_TargetOrigin"                         = trimsuffix(var.client_BASE_URL, "/")
    "DataAreaID"                              = var.B2C_DATAAREA_ID
    "DefaultDeliveryMode"                     = var.DEFAULT_DELIVERY_MODE
    "devicetoken"                             = var.POS_DEVICE_TOKEN
    "email_host"                              = var.EMAIL_SMTP_HOST
    "emailDisplayName"                        = var.EMAIL_SENDER_NAME
    "host"                                    = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "grant_type"                              = "client_credentials"
    "isRelease"                               = "true"
    "KeyVaultUrl"                             = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuthTokenPOSUri"                        = "${var.D365_RETAIL_BASE_URL}/Auth/token"
    "UsernamePOS"                             = var.POS_USERNAME
    "pos_grant_type"                          = var.POS_GRANT_TYPE
    "OAuthTokenUri"                           = var.OAUTH_TOKEN_URI
    "OUN"                                     = var.OAUTH_OUN
    "Password"                                = var.POS_PASSWORD
    "resource"                                = var.OAUTH_RESOURCE
    "SearchSalesOrderUsingChannelReferanceID" = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersEComOrderId?$skip=0&$top=100&api-version=7.1"
     "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "SearchSalesOrderUsingCustomerIDUri"      = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersAsync?$skip=0&$top=100&api-version=7.1"
    "ServiceAccountId"                        = var.SERVICE_ACCOUNT_ID
    "StorageAccountName"                      = "az2clientprodclstorage"
    "templateFolder"                          = "templates/"
    "UploadSalesOrderUri"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_UploadOrderAsync"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = var.connectionstring
    "WEBSITE_CONTENTSHARE"                     = "staging7c4c"
    "ProductAttributeCall"                     = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetAttributeValuesAsync?$skip=0&$top=100&api-version=7.1"
    "ProductByCategoriesCall"                  = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/Search?$skip=0&$top=1000&api-version=7.1"
    "ProductByCategoriesCallNew"               = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ProductDimensionsCall"                    = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "VarianrDimensionsCall"                    = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetCustomVariantDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "VariantsByMasterProductCall"              = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/Search?$skip=0&$top=100&api-version=7.1"
    "VariantsByVariantIds"                     = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetAllProducts?$skip=0&$top=1000&api-version=7.1"
    "variantIdsByMasterProduct"                = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetProductsVariantIds"
    "scm_type"                                 = "VSTSRM"
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_function_app_slot" "az2_client_prod_salesorder_func_slot" {
  name                       = "staging"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  function_app_name          = azurerm_function_app.az2_client_prod_salesorder_func.name
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "APIM-IP"
      ip_address  = "20.114.215.181/32"
      priority    = "2"
    }
    ip_restriction {
      name        = "APIM-Subnet"
     virtual_network_subnet_id = azurerm_subnet.apim_subnet.id
      priority    = "3"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                = "1"
    "FUNCTIONS_EXTENSION_VERSION"             = "~3"
    "FUNCTIONS_WORKER_RUNTIME"                = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"                = "1"
    "client_GetSalesOrderPool"                   = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_GetSalesOrderPool"
    "client_SalesOrderExtended"                  = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersExtended?$skip=0&$top=100&api-version=7.1"
    "client_SalesOrderExtendedRefined"           = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_GetRefinedOrderHistory"
    "client_SalesOrderPoolUpdate"                = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SalesOrderPoolUpdate?api-version=7.1"
    "client_SearchOrderAsync"                    = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersAsync?$skip=0&$top=100&api-version=7.1"
    "clientBaseURL"                             = var.client_BASE_URL
    "assetBaseURL"                            = var.ASSETS_BASE_URL
    "AzureWebJobsStorage"                     = var.LOG_STORAGE_CONNECTION
    "BaseURL"                                 = "${var.D365_RETAIL_BASE_URL}/Commerce/"
    "CartApi"                                 = "${var.D365_RETAIL_BASE_URL}/Commerce/Carts"
    "Client_Id_POS"                           = var.POS_CLIENT_ID
    "CS_EncryptionKey"                        = "RsaOaep"
    "CS_format"                               = "JWT"
    "CS_Host"                                 = var.CYBERSOURCE_IS_PRODCTION ? "api.cybersource.com" : "apitest.cybersource.com"
    "CS_TargetOrigin"                         = trimsuffix(var.client_BASE_URL, "/")
    "DataAreaID"                              = var.B2C_DATAAREA_ID
    "DefaultDeliveryMode"                     = var.DEFAULT_DELIVERY_MODE
    "devicetoken"                             = var.POS_DEVICE_TOKEN
    "email_host"                              = var.EMAIL_SMTP_HOST
    "emailDisplayName"                        = var.EMAIL_SENDER_NAME
    "host"                                    = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "grant_type"                              = "client_credentials"
    "isRelease"                               = "true"
    "KeyVaultUrl"                             = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuthTokenPOSUri"                        = "${var.D365_RETAIL_BASE_URL}/Auth/token"
    "UsernamePOS"                             = var.POS_USERNAME
    "pos_grant_type"                          = var.POS_GRANT_TYPE
    "OAuthTokenUri"                           = var.OAUTH_TOKEN_URI
    "OUN"                                     = var.OAUTH_OUN
    "Password"                                = var.POS_PASSWORD
    "resource"                                = var.OAUTH_RESOURCE
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "SearchSalesOrderUsingChannelReferanceID" = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersEComOrderId?$skip=0&$top=100&api-version=7.1"
    "SearchSalesOrderUsingCustomerIDUri"      = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_SearchOrdersAsync?$skip=0&$top=100&api-version=7.1"
    "ServiceAccountId"                        = var.SERVICE_ACCOUNT_ID
    "StorageAccountName"                      = "az2clientprodclstorage"
    "templateFolder"                          = "templates/"
    "UploadSalesOrderUri"                     = "${var.D365_RETAIL_BASE_URL}/Commerce/SalesOrders/client_UploadOrderAsync"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
    "ProductAttributeCall"                    = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetAttributeValuesAsync?$skip=0&$top=100&api-version=7.1"
    "ProductByCategoriesCall"                 = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/Search?$skip=0&$top=1000&api-version=7.1"
    "ProductByCategoriesCallNew"              = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ProductDimensionsCall"                   = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "VarianrDimensionsCall"                   = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetCustomVariantDimensionValuesAsync?$skip=0&$top=1000&api-version=7.1"
    "VariantsByMasterProductCall"             = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/Search?$skip=0&$top=100&api-version=7.1"
    "VariantsByVariantIds"                    = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetAllProducts?$skip=0&$top=1000&api-version=7.1"
    "variantIdsByMasterProduct"               = "https://scu653mafdq11136721-rs.su.retail.dynamics.com/Commerce/Products/client_GetProductsVariantIds"
  }
  tags = {
    Environment = "PROD"
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "salesorder-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_salesorder_func.id
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "salesorder-slot-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_salesorder_func.id
  slot_name      = azurerm_function_app_slot.az2_client_prod_salesorder_func_slot.name
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_function_app" "az2_client_prod_pricing_func" {
  name                       = "az2-client-prod-pricing-func"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "function-Subnet"
     virtual_network_subnet_id = azurerm_subnet.function_subnet.id
      priority    = "13"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
# AzureWebJobsDashboard was added manually in Azure and backed in. Check later.
    "AzureWebJobsDashboard"       = var.connectionstring
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "CategoryApi"                 = "${var.D365_RETAIL_BASE_URL}/Commerce/Categories/GetCategories?$skip=0&$top=1000&api-version=7.1"
    "channelId"                   = var.CHANNEL_ID
    "hedo"                        = "client"
    "hostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "grant_type"                  = "client_credentials"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "resource"                    = var.OAUTH_RESOURCE
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "restartURL"                  = var.FUNCTION_URL_PRICING_SYNC
    "StorageAccountName"          = var.LOG_STORAGE_NAME
    "ProductByCategoryApi"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ActivePricesApi"             = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetActiveProductPriceAsync?$skip=0&$top=1000&api-version=7.1"
    "ActivePricesByLocationApi"   = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetProductActivePrice"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
  }
  tags = {
    Environment = "PROD"
  }
}

resource "azurerm_function_app_slot" "az2_client_prod_pricing_func_slot" {
  name                       = "staging"
  location                   = "East US 2"
  resource_group_name        = azurerm_resource_group.az2_client_prod_customlayer_rsg.name
  app_service_plan_id        = azurerm_app_service_plan.az2_client_prod_customlayer-asp.id
  function_app_name          = azurerm_function_app.az2_client_prod_pricing_func.name
  storage_account_name       = azurerm_storage_account.az2clientprodclstg.name
  storage_account_access_key = azurerm_storage_account.az2clientprodclstg.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on     = "true"
    ftps_state    = "Disabled"
    http2_enabled = "true"
    ip_restriction {
      service_tag = "AppService"
      name        = "Restrict access to the FrontEnd"
      priority    = 300
    }
    ip_restriction {
      name        = "function-Subnet"
     virtual_network_subnet_id = azurerm_subnet.function_subnet.id
      priority    = "13"
    }
  }
  app_settings = {

    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AzureWebJobsStorage"         = var.LOG_STORAGE_CONNECTION
    "CategoryApi"                 = "${var.D365_RETAIL_BASE_URL}/Commerce/Categories/GetCategories?$skip=0&$top=1000&api-version=7.1"
    "channelId"                   = var.CHANNEL_ID
    "hedo"                        = "client"
    "hostURL"                     = trimprefix(var.D365_RETAIL_BASE_URL, "https://")
    "isRelease"                   = "true"
    "grant_type"                  = "client_credentials"
    "KeyVaultUrl"                 = "https://az2-client-prod-cust-kv.vault.azure.net/"
    "OAuth"                       = var.OAUTH_TOKEN_URI
    "OUN"                         = var.OAUTH_OUN
    "resource"                    = var.OAUTH_RESOURCE
    "RedisConnection"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.az2_client_prod_cust_kv.vault_uri}secrets/${data.azurerm_key_vault_secret.Redis_Connection.name}/${data.azurerm_key_vault_secret.Redis_Connection.version})"
    "restartURL"                  = var.FUNCTION_URL_PRICING_SYNC
    "StorageAccountName"          = var.LOG_STORAGE_NAME
    "ProductByCategoryApi"        = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/SearchByCategory(channelId={channelId},catalogId=0,categoryId={categoryId})?$skip=0&$top=100&api-version=7.1"
    "ActivePricesApi"             = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetActiveProductPriceAsync?$skip=0&$top=1000&api-version=7.1"
    "ActivePricesByLocationApi"   = "${var.D365_RETAIL_BASE_URL}/Commerce/Products/client_GetProductActivePrice"
    "APPINSIGHTS_INSTRUMENTATIONKEY"    = azurerm_application_insights.az2_client_prod_customlayer_ai.instrumentation_key
  }
  tags = {
    Environment = "PROD"
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "pricing-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_pricing_func.id
  subnet_id      = azurerm_subnet.function_subnet.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "pricing-slot-vnet-connection" {
  app_service_id = azurerm_function_app.az2_client_prod_pricing_func.id
  slot_name      = azurerm_function_app_slot.az2_client_prod_pricing_func_slot.name
  subnet_id      = azurerm_subnet.function_subnet.id
}
