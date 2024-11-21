resource "azurerm_subnet" "sub1" {
  count                = 2
  name                 = "${var.vnet_name}-sub-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [element(var.cidr_address, count.index)]

}
