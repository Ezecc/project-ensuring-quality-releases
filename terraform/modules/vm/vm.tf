resource "azurerm_network_interface" "test" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.prefix}-vm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.test.id]

  admin_ssh_key {
    username   = var.admin_username
    #username   = "chijioke"
    #public_key = "file("~/.ssh/az_eqr_id_rsa.pub")"
    public_key = ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnw+6ieEt97stEA6q3KOn/F5KoX1gpemji+rRUjitOugmpRXDyp4jMF7TPcCIYGArL/Z4h/zLnAYfcHe/koDqsGdlqWe+HO84Cv1+OUV60iVbGYFtxh7YyI2bz9LQST711SxLoiIkzi6ahK28jvLWGpi/oK7/8WTJ/tz6VcN3QNLOMe4faCRHgETG7lnCVt2WeBtKvbqwmmBiyYv1maUc0sa/ztDOdGGOfuEHh08l4KGfEa6heerJxtYkFk9XbONmcQh5DsQXGqov4DlVexPavhCMYnuOGVFKBL1pxBX1db94YQ9nGeXJ4/VOV9fvJgKJpXY7AfmPok0ySm3pDHe0oTFbMOsUxOea+V0jdRjEeP0GjKIMrJzlzKPl3oI2AvabcTgTVQ28vFYiOLnr2Ser7nEZ0hKNOny5QFla22HYPXmPG4qMkcuB4tNaqAfjaNNitzyIxveo7pbLWfOnYCF0IsNz3x/DG5bqAC57X9A+QeBEeM02o38rAO0hdcw3Wgk8= chijioke@cc-ce579c8e-6755b778b8-c5cqx

  }
    os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
