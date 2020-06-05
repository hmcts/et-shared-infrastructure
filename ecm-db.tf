module "ecm-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=master"
  product            = "${var.product}-shared-ecm-db"
  location           = var.location
  env                = var.env
  postgresql_user    = "ecmconsumer"
  database_name      = "ecmconsumer"
  postgresql_version = "11"
  sku_name           = "GP_Gen5_2"
  sku_tier           = "GeneralPurpose"
  storage_mb         = "51200"
  common_tags        = var.common_tags
  subscription       = var.subscription
}

resource "azurerm_key_vault_secret" "ecm-postgres-user" {
  name         = "ecmconsumer-postgres-user"
  value        = module.ecm-database.user_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm-postgres-password" {
  name         = "ecmconsumer-postgres-password"
  value        = module.ecm-database.postgresql_password
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm-postgres-host" {
  name         = "ecmconsumer-postgres-host"
  value        = module.ecm-database.host_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm-postgres-port" {
  name         = "ecmconsumer-postgres-port"
  value        = module.ecm-database.postgresql_listen_port
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm-postgres-database" {
  name         = "ecmconsumer-postgres-database"
  value        = module.ecm-database.postgresql_database
  key_vault_id = module.key-vault.key_vault_id
}