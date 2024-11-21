data "azurerm_dns_zone" "azure99" {
  name                = "azure99.xyz"
  resource_group_name = "common_RG"
}

#Create DNS Record for Azure Load Balancer
resource "azurerm_dns_a_record" "slb" {
  name                = "azslb"
  zone_name           = data.azurerm_dns_zone.azure99.name
  resource_group_name = data.azurerm_dns_zone.azure99.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.azlb-pip.ip_address]
}