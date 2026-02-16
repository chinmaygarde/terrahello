resource "azurerm_virtual_network" "terrahello" {
  name = "terrahello"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name
}

resource "azurerm_subnet" "vm" {
  name = "vm"
  resource_group_name = azurerm_resource_group.terrahello.name
  virtual_network_name = azurerm_virtual_network.terrahello.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "vm" {
  name = "vm"
  location = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    name = "vm"
    subnet_id = azurerm_subnet.vm.id
  }
}

resource "azurerm_linux_virtual_machine" "linux1" {
  name                = "linux1"
  resource_group_name = azurerm_resource_group.terrahello.name
  location            = azurerm_resource_group.terrahello.location
  size                = "Standard_F1ads_v7"

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  admin_username      = var.admin_user
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_user
    public_key = var.admin_pubkey
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
