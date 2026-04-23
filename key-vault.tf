module "et-key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "${var.product}-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  jenkins_object_id       = data.azurerm_user_assigned_identity.jenkins.principal_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Employment Tribunals"
  common_tags             = var.common_tags
  create_managed_identity = true
}

data "azurerm_user_assigned_identity" "jenkins" {
  name                = "jenkins-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azurerm_key_vault" "et_cos_vault" {
  name                = "et-cos-${var.env}"
  resource_group_name = "et-cos-${var.env}"
}

data "azurerm_key_vault_secret" "et_cos_system_user" {
  name         = "cos-system-user"
  key_vault_id = data.azurerm_key_vault.et_cos_vault.id
}

data "azurerm_key_vault_secret" "et_cos_system_user_password" {
  name         = "cos-system-user-password"
  key_vault_id = data.azurerm_key_vault.et_cos_vault.id
}

resource "azurerm_key_vault_secret" "definition-importer-username" {
  name         = "definition-importer-username"
  value        = data.azurerm_key_vault_secret.et_cos_system_user.value
  key_vault_id = module.et-key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "definition-importer-password" {
  name         = "definition-importer-password"
  value        = data.azurerm_key_vault_secret.et_cos_system_user_password.value
  key_vault_id = module.et-key-vault.key_vault_id
}
