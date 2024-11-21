resource "null_resource" "testvm" {
  count = var.environment == "dev" ? 2 : 1
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    connection {
      type     = "ssh"
      user     = "adminsree"
      password = element(azurerm_key_vault_secret.passwords.*.value, count.index)
      host     = element(azurerm_public_ip.testvm_pip.*.ip_address, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
    connection {
      type     = "ssh"
      user     = "adminsree"
      password = element(azurerm_key_vault_secret.passwords.*.value, count.index)
      host     = element(azurerm_public_ip.testvm_pip.*.ip_address, count.index)
    }
  }
  #This resouce will be recreated if there is a changein tag version.
  triggers = {
    public-servers-tags = element(azurerm_linux_virtual_machine.testvm.*.tags.Version, count.index)
  }

  depends_on = [
    azurerm_linux_virtual_machine.testvm,
  ]
}