# Azure Managed Redis for et-sya / et-syr session storage.
#
# Deployed alongside module.et-session-storage: the frontends dual-write to both
# instances, then reads flip, then the classic cache is dropped.
module "et-managed-redis" {
  source = "git@github.com:hmcts/terraform-module-azure-managed-redis?ref=main"

  product                      = var.product
  component                    = "managed-redis"
  env                          = var.env
  location                     = var.location
  existing_resource_group_name = azurerm_resource_group.rg.name
  common_tags                  = var.common_tags

  sku_name                  = var.managed_redis_sku_name
  high_availability_enabled = var.managed_redis_high_availability_enabled

  public_network_access   = "Disabled"
  create_private_endpoint = true
  subnet_id               = data.azurerm_subnet.managed_redis_private_endpoint.id
  private_dns_zone_ids = [
    "/subscriptions/${var.private_dns_subscription_id}/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.redis.azure.net"
  ]

  # node-redis v3, used by both frontends, cannot follow OSS cluster redirects.
  clustering_policy = "EnterpriseCluster"
  client_protocol   = "Encrypted"
  eviction_policy   = "VolatileLRU"

  # Key auth for parity with the classic cache; the frontends authenticate with
  # a password, not a managed identity.
  access_keys_authentication_enabled = true

  persistence_rdb_backup_frequency = var.managed_redis_rdb_backup_frequency
}

data "azurerm_subnet" "managed_redis_private_endpoint" {
  name                 = "core-infra-subnet-2-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
}

resource "azurerm_key_vault_secret" "et_managed_redis_access_key" {
  name         = "et-managed-redis-access-key"
  value        = module.et-managed-redis.primary_access_key
  key_vault_id = module.et-key-vault.key_vault_id
}

# Until now the frontends signed session cookies with the Redis access key, which
# tied cookie validity to the cache being migrated. Give them a dedicated secret so
# the two can be rotated independently.
resource "random_password" "et_session_secret" {
  length  = 64
  special = false
}

resource "azurerm_key_vault_secret" "et_session_secret" {
  name         = "et-session-secret"
  value        = random_password.et_session_secret.result
  key_vault_id = module.et-key-vault.key_vault_id
}
