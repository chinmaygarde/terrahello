data "azurerm_key_vault_secret" "domain_name" {
  name         = "domain-name"
  key_vault_id = azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "cloudflare_api_token" {
  name         = "cloudflare-api-token"
  key_vault_id = azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "cloudflare_zone_id" {
  name         = "cloudflare-zone-id"
  key_vault_id = azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "cloudflare_account_id" {
  name         = "cloudflare-account-id"
  key_vault_id = azurerm_key_vault.vault.id
}
