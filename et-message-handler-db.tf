module "et-message-handler-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=master"
  product            = "${var.product}-et-message-handler-postgres-db"
  location           = var.location
  env                = var.env
  postgresql_user    = "et_message_handler"
  database_name      = "et_message_handler"
  postgresql_version = "11"
  sku_name           = "GP_Gen5_2"
  sku_tier           = "GeneralPurpose"
  storage_mb         = "51200"
  common_tags        = local.common_tags
  subscription       = var.subscription
}

resource "azurerm_key_vault_secret" "et_message_handler_postgres_user" {
  name         = "et-message-handler-postgres-user"
  value        = module.et-message-handler-database.user_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_message_hander_postgres_password" {
  name         = "et-message-handler-postgres-password"
  value        = module.et-message-handler-database.postgresql_password
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_message_handler_postgres_host" {
  name         = "et-consumer-postgres-host"
  value        = module.et-message-handler-database.host_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_message_handler_postgres_port" {
  name         = "et-message-handler-postgres-port"
  value        = module.et-message-handler-database.postgresql_listen_port
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "et_message_handler_postgres_database" {
  name         = "et-message-handler-postgres-database"
  value        = module.et-message-handler-database.postgresql_database
  key_vault_id = module.key-vault.key_vault_id
}