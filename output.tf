output "vaultName" {
  value = module.et-key-vault.key_vault_name
}

output "vaultUri" {
  value = module.et-key-vault.key_vault_uri
}

output "managedRedisHostname" {
  value = module.et-managed-redis.hostname
}

output "managedRedisPort" {
  value = module.et-managed-redis.port
}

output "openaiAccountId" {
  value = module.openai_services.cognitive_account_id
}

output "openaiEndpoint" {
  value = one(module.openai_services.cognitive_account_endpoint)
}

output "openaiPrivateEndpointDns" {
  value = azurerm_private_endpoint.openai.custom_dns_configs
}
