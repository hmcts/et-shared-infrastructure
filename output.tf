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
