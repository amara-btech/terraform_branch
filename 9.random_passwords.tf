resource "random_password" "vmpassword" {
  length           = 16
  special          = true
  override_special = "!#$?"
}

