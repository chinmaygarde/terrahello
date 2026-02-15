# This is where the resources are defined.

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg_terrahello" {
  name     = "terrahello"
  location = "West US 2"
}

resource "azurerm_storage_account" "sa_web" {
  location                 = azurerm_resource_group.rg_terrahello.location
  resource_group_name      = azurerm_resource_group.rg_terrahello.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  name                     = "terrahellosaweb"
}

resource "azurerm_storage_account_static_website" "sa_web" {
  storage_account_id = azurerm_storage_account.sa_web.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

output "sa_web_url" {
  value = azurerm_storage_account.sa_web.primary_web_endpoint
}
