# resource "azurerm_storage_account" "terraformvartf" {
#   name                     = var.strg_account
#   location                 = "eastus"
#   resource_group_name      = "common_RG"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = var.environment
#   }
# }

# resource "azurerm_storage_container" "tfstate" {
#   name                  = "tfstate"
#   storage_account_id    = azurerm_storage_account.terraformvartf.id
#   container_access_type = "private"
# }