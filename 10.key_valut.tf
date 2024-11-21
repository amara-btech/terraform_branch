data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "terraformseckey" {
  name                       = "terraformseckey"
  location                   = azurerm_resource_group.rg1.location
  resource_group_name        = azurerm_resource_group.rg1.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id #"e1014fe4-0f8d-4514-b180-df1772483e3b"
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}
resource "azurerm_key_vault_access_policy" "terraformpolicy" {
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id #"e998cbf5-9f9a-49e1-8b97-b4670636213d"
  key_vault_id = azurerm_key_vault.terraformseckey.id

  key_permissions = [
    "Create",
    "Get",
    "List",
    "Update",
    "Import",
    "Delete",
    "Recover",
    "Backup"
  ]

  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover",
    "List"

  ]
}

resource "azurerm_key_vault_access_policy" "amara_policy" {
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "67df5c88-65ee-4261-8b4e-a1a492689fe7"
  key_vault_id = azurerm_key_vault.terraformseckey.id

  key_permissions = [
    "Create",
    "Get",
    "List",
    "Update",
    "Import",
    "Delete",
    "Recover",
    "Backup"
  ]

  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover",
    "List"

  ]
}


resource "azurerm_key_vault_secret" "passwords" {
  count        = 2
  name         = "vmpassword-${count.index}"
  value        = element(random_password.vmpassword.*.result, count.index)
  key_vault_id = azurerm_key_vault.terraformseckey.id
}
