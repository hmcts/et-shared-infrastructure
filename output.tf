output "vaultName" {
  value = module.et-key-vault.key_vault_name
}

output "vaultUri" {
  value = module.et-key-vault.key_vault_uri
}

output "appInsightsInstrumentationKey" {
  sensitive = true
  value     = azurerm_application_insights.appinsights.instrumentation_key
}
