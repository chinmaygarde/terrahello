# This is where providers are defined.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.60.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terrahello-tfstate"
    storage_account_name = "terrahellotfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_cli              = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "cloudflare" {
  api_token = data.azurerm_key_vault_secret.cloudflare_api_token.value
}
