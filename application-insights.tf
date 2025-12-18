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

# Deprecated: API Keys are being retired in March 2026
# TODO: Remove after all applications migrate to connection string or Azure AD auth
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

# Grant Monitoring Reader role to slack alerts function app (Step 3 from migration guide)
resource "azurerm_role_assignment" "slack_alerts_monitoring_reader" {
  count                = var.env == "prod" ? 1 : 0
  scope                = module.application_insights.id
  role_definition_name = "Monitoring Reader"
  principal_id         = local.slack_alerts_principal_id
}
