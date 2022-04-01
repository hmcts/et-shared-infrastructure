terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.25"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private-endpoint"
  subscription_id            = var.aks_subscription_id
}