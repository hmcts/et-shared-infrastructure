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
# Can be provided via variable or uses hardcoded default for prod
# Hardcoded because pipeline service principal lacks access to subscription b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb
# If function app is recreated, update this ID from: az functionapp identity show --name et-slack-alerts-func --resource-group et-slack-alerts-rg --query principalId -o tsv
locals {
  # Use variable if provided, otherwise use hardcoded prod value
  slack_alerts_principal_id = var.slack_alerts_principal_id != "" ? var.slack_alerts_principal_id : (
    var.env == "prod" ? "31b0c542-4a7e-4175-9d0c-0a343c7f7a05" : null
  )
}
