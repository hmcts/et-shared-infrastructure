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
  value = var.enable_openai ? module.openai_services[0].cognitive_account_id : null
}

output "openaiEndpoint" {
  value = var.enable_openai ? one(module.openai_services[0].cognitive_account_endpoint) : null
}

output "openaiEuAccountId" {
  value = var.enable_openai_eu ? module.openai_services_eu[0].cognitive_account_id : null
}

output "openaiEuEndpoint" {
  value = var.enable_openai_eu ? one(module.openai_services_eu[0].cognitive_account_endpoint) : null
}
