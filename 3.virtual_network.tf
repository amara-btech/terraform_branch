resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "dev"
  }
}