data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault" "vault" {
  name = "terrahellovault"
  location = azurerm_resource_group.terrahello.location
  resource_group_name = azurerm_resource_group.terrahello.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days = 7
  purge_protection_enabled = true
  rbac_authorization_enabled = true
}

resource "azurerm_role_assignment" "vault_admin" {
  scope = azurerm_key_vault.vault.id
  principal_id = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Secrets Officer"
}
