# This is where the resources are defined.

# Create a resource group in Azure.
resource "azurerm_resource_group" "terrahello" {
  name     = "terrahello"
  location = "West US 2"
}

# Create a storage account for the website.
resource "azurerm_storage_account" "web" {
  location                 = azurerm_resource_group.terrahello.location
  resource_group_name      = azurerm_resource_group.terrahello.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  name                     = "terrahellosaweb"
  custom_domain {
    name          = "demo.${data.azurerm_key_vault_secret.domain_name.value}"
  }
}

# Host the website from the storage account.
resource "azurerm_storage_account_static_website" "web" {
  storage_account_id = azurerm_storage_account.web.id
  index_document     = "index.html"
  error_404_document = "404_custom.html"
}

resource "cloudflare_dns_record" "cname_demo" {
  zone_id = data.azurerm_key_vault_secret.cloudflare_zone_id.value
  name    = "demo"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  content = azurerm_storage_account.web.primary_web_host
  comment = "Primary Endpoint for Static Website Hosted on Azure"
}

resource "cloudflare_dns_record" "cname_asverify_demo" {
  zone_id = data.azurerm_key_vault_secret.cloudflare_zone_id.value
  name    = "asverify.${cloudflare_dns_record.cname_demo.name}"
  ttl     = 3600
  type    = "CNAME"
  content = "asverify.${azurerm_storage_account.web.primary_web_host}"
  comment = "Intermdiate CNAME record for Static Website Hosted on Azure"
  proxied = false
}
