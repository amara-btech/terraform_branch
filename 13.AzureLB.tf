locals {
  rg_name = "${var.rg_name}-${var.environment}"
}

# Create Public IP for Azure Load Balancer
resource "azurerm_public_ip" "azlb-pip" {
  name                = join("-", [local.rg_name, "slb-pip"])
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creating Standard Load Balancer
resource "azurerm_lb" "azslb" {
  name                = join("-", [local.rg_name, "slb"])
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.azlb-pip.id
  }
}

#Creating LB Backend Pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name            = join("-", [local.rg_name, "be-pool-1"])
  loadbalancer_id = azurerm_lb.azslb.id
}

#Creating LB Probe
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.azslb.id
}

#Creating LB Rule
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.azslb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.azslb.id
}

#Associate Network Interface and Standard Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  count                   = var.environment == "Dev" || var.environment == "dev" ? 2 : 1
  network_interface_id    = element(azurerm_network_interface.testvm_nic.*.id, count.index)
  ip_configuration_name   = "testvm-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}

