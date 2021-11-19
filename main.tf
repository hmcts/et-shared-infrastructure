provider "azurerm" {
  features {}
}

locals {
  tags = merge(var.common_tags,
    map(
      "environment", var.env,
      "managedBy", var.team_name,
      "Team Contact", var.team_contact
      "lastUpdated", timestamp()
    )
  )
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = local.tags
}
