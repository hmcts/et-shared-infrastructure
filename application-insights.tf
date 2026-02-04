module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=4.x"

  env      = var.env
  product  = var.product
  location = var.location

  resource_group_name = azurerm_resource_group.rg.name
  alert_limit_reached = true
  common_tags         = var.common_tags
}

moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights.azurerm_application_insights.this
}

resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.application_insights.connection_string
  key_vault_id = module.et-key-vault.key_vault_id
}

# Workspace ID for Azure AD authenticated queries
data "azurerm_application_insights" "this" {
  name                = module.application_insights.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_secret" "app_insights_workspace_id" {
  name         = "app-insights-workspace-id"
  value        = data.azurerm_application_insights.this.workspace_id
  key_vault_id = module.et-key-vault.key_vault_id
}

# Grant Monitoring Reader role to slack alerts function app
# This allows the function app to query Application Insights using Azure AD authentication
resource "azurerm_role_assignment" "slack_alerts_monitoring_reader" {
  scope                = data.azurerm_application_insights.this.id
  role_definition_name = "Monitoring Reader"
  principal_id         = local.slack_alerts_principal_id
}
