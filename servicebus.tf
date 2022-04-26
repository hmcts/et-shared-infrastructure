module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  env                 = var.env
  common_tags         = local.tags
}

module "create-updates-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "create-updates"
  namespace_name      = module.servicebus-namespace.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

module "update-case-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "update-case"
  namespace_name      = module.servicebus-namespace.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "create_updates_queue_send_conn_str" {
  name      = "create-updates-queue-send-connection-string"
  value     = module.create-updates-queue.primary_send_connection_string
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "create_updates_queue_listen_conn_str" {
  name      = "create-updates-queue-listen-connection-string"
  value     = module.create-updates-queue.primary_listen_connection_string
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "create_updates_queue_max_delivery_count" {
  name      = "create-updates-queue-max-delivery-count"
  value     = var.queue_max_delivery_count
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_queue_send_conn_str" {
  name      = "update-case-queue-send-connection-string"
  value     = module.update-case-queue.primary_send_connection_string
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_queue_listen_conn_str" {
  name      = "update-case-queue-listen-connection-string"
  value     = module.update-case-queue.primary_listen_connection_string
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_queue_max_delivery_count" {
  name      = "update-case-queue-max-delivery-count"
  value     = var.queue_max_delivery_count
  key_vault_id = module.et-key-vault.key_vault_id
}

# endregion

output "create_updates_queue_primary_listen_connection_string" {
  sensitive = true
  value     = module.create-updates-queue.primary_listen_connection_string
}

output "create_updates_queue_primary_send_connection_string" {
  sensitive = true
  value     = module.create-updates-queue.primary_send_connection_string
}

output "update_case_queue_primary_listen_connection_string" {
  sensitive = true
  value     = module.update-case-queue.primary_listen_connection_string
}

output "update_case_queue_primary_send_connection_string" {
  sensitive = true
  value     = module.update-case-queue.primary_send_connection_string
}

output "queue_max_delivery_count" {
  value = var.queue_max_delivery_count
}