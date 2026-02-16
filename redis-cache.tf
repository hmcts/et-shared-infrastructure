module "et-session-storage" {
  source                        = "git@github.com:hmcts/cnp-module-redis?ref=4.x"
  product                       = "${var.product}-session-storage"
  location                      = var.location
  env                           = var.env
  private_endpoint_enabled      = true
  redis_version                 = "6"
  business_area                 = "cft"
  public_network_access_enabled = false
  common_tags                   = var.common_tags
  sku_name                      = var.sku_name
  family                        = var.family
  capacity                      = var.capacity
}

resource "azurerm_key_vault_secret" "et-redis_access_key" {
  name         = "et-redis-access-key"
  value        = module.et-session-storage.access_key
  key_vault_id = module.et-key-vault.key_vault_id
}