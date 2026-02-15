# This is where providers are defined.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.60.0"
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
