provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
}

locals {
  tagEnv = var.env == "aat" ? "staging" : var.env
  common_tags = {
    "environment"  = local.tagEnv
    "managedBy"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "application"  = var.product
    "businessArea" = var.businessArea
    "builtFrom"    = var.builtFrom
  }
}