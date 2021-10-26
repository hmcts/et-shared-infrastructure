module "et-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=master"
  product            = "${var.product}-shared-et-db"
  location           = var.location
  env                = var.env
  postgresql_user    = "etconsumer"
  database_name      = "etconsumer"
  postgresql_version = "11"
  sku_name           = "GP_Gen5_2"
  sku_tier           = "GeneralPurpose"
  storage_mb         = "51200"
  common_tags        = local.common_tags
  subscription       = var.subscription
}

resource "azurerm_key_vault_secret" "et_postgres_user" {
  name         = "et-consumer-postgres-user"
  value        = module.et-database.user_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_postgres_password" {
  name         = "et-consumer-postgres-password"
  value        = module.et-database.postgresql_password
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_postgres_host" {
  name         = "et-consumer-postgres-host"
  value        = module.et-database.host_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_postgres_port" {
  name         = "et-consumer-postgres-port"
  value        = module.et-database.postgresql_listen_port
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_postgres_database" {
  name         = "et-consumer-postgres-database"
  value        = module.et-database.postgresql_database
  key_vault_id = module.key-vault.key_vault_id
}