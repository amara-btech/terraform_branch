# Create public IPs
resource "azurerm_public_ip" "testvm_pip" {
  count               = 2
  name                = "testvm-pip${count.index}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Create network interface
resource "azurerm_network_interface" "testvm_nic" {
  count               = 2
  name                = "testvm-nic${count.index}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testvm-ipconfig"
    subnet_id                     = element(azurerm_subnet.sub1.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.testvm_pip.*.id, count.index)

  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "testvm" {
  count                           = 2
  name                            = "${var.rg_name}-testvm-${count.index}"
  location                        = azurerm_resource_group.rg1.location
  resource_group_name             = azurerm_resource_group.rg1.name
  network_interface_ids           = [element(azurerm_network_interface.testvm_nic.*.id, count.index)]
  size                            = var.vm_size
  disable_password_authentication = false
  os_disk {
    name                 = "myOsDisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  tags = {
    Version = "2.0"
  }
  computer_name  = "${var.vm_name}-${count.index + 1}"
  admin_username = var.username
  admin_password = element(azurerm_key_vault_secret.passwords.*.value, count.index)

  lifecycle {
    ignore_changes = [
      tags
    ]
    prevent_destroy = false
    #  create_before_destroy = true
  }
}