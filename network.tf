resource "azurerm_virtual_network" "terrahello" {
  name                = "terrahello"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name
  dns_servers         = ["1.1.1.1"]
}

resource "azurerm_subnet" "vm" {
  name                 = "vm"
  resource_group_name  = azurerm_resource_group.terrahello.name
  virtual_network_name = azurerm_virtual_network.terrahello.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "linux1_public_ip" {
  name                = "linux1_public_ip"
  resource_group_name = azurerm_resource_group.terrahello.name
  location            = azurerm_resource_group.terrahello.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "allow_ssh" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_network_interface" "vm" {
  name                = "vm"
  location            = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    name                          = "vm"
    subnet_id                     = azurerm_subnet.vm.id
    public_ip_address_id          = azurerm_public_ip.linux1_public_ip.id
  }
}

data "azurerm_key_vault_secret" "admin_pubkey" {
  name         = "admin-pubkey"
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_linux_virtual_machine" "linux1" {
  name                = "linux1"
  resource_group_name = azurerm_resource_group.terrahello.name
  location            = azurerm_resource_group.terrahello.location
  size                = "Standard_F1ads_v7"

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  admin_username                  = var.admin_user
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_user
    public_key = data.azurerm_key_vault_secret.admin_pubkey.value
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
