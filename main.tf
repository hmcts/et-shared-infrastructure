provider "azurerm" {
  features {}
}

# Provider for the subscription where slack alerts function app exists
provider "azurerm" {
  alias           = "slack_alerts"
  subscription_id = var.slack_alerts_subscription_id
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

# Reference slack alerts function app in separate subscription/resource group
data "azurerm_linux_function_app" "slack_alerts" {
  count               = var.env == "prod" ? 1 : 0
  provider            = azurerm.slack_alerts
  name                = "et-slack-alerts-func"
  resource_group_name = "et-slack-alerts-rg"
}
