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

# Slack alerts function app managed identity principal ID
# Hardcoded because pipeline service principal lacks access to subscription b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb
# If function app is recreated, update this ID from: az functionapp identity show --name et-slack-alerts-func --resource-group et-slack-alerts-rg --query principalId -o tsv
locals {
  slack_alerts_principal_id = "31b0c542-4a7e-4175-9d0c-0a343c7f7a05"
}
