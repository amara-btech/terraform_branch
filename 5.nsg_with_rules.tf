resource "azurerm_network_security_group" "rg1-nsg1" {
  name                = "${var.rg_name}-nsg1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_network_security_rule" "rg1-nsg1_allow_all" {
  name                        = "rg1-nsg1_allow_all"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.rg1-nsg1.name
}

resource "azurerm_subnet_network_security_group_association" "rg1-subnet-nsg1" {
  #count                     = 2
  count                     = length(var.cidr_address)
  subnet_id                 = element(azurerm_subnet.sub1[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.rg1-nsg1.id
}