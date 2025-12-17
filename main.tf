provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
  lifecycle {
    ignore_changes = all
  }
}

data "azurerm_linux_function_app" "slack_alerts" {
  count               = var.env == "prod" ? 1 : 0
  name                = "et-slack-alerts-func"
  resource_group_name = "et-slack-alerts-rg"
}