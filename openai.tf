# Azure OpenAI (AIServices) in UK South (BYO backend for HMCTS AI Gateway).
# Provisioned via hmcts/terraform-module-ai-services with Entra-only auth
# (local_auth_enabled = false), public network access disabled, and network ACLs
# set to Deny (required by platform-ai-gateway-infra's byo_baseline check).
#
# Networking & DNS: platform-ai-gateway-infra creates and manages its own Private
# Endpoint (azurerm_private_endpoint.byo) and Private DNS Zone Group to reach
# this account, so no AKS Private Endpoint or azure-private-dns PR is needed here.

module "openai_services" {
  count  = var.enable_openai ? 1 : 0
  source = "git@github.com:hmcts/terraform-module-ai-services?ref=main"

  providers = {
    azurerm.private_dns = azurerm
  }

  env         = var.env
  product     = var.product
  project     = "cft"
  component   = "openai"
  common_tags = var.common_tags

  existing_resource_group_name    = azurerm_resource_group.rg.name
  existing_cognitive_account_name = "${var.product}-openai-${var.env}"
  location                        = var.location

  create_ai_foundry        = false
  create_storage_account   = false
  create_cognitive_account = true
  enable_managed_network   = false

  cognitive_account_kind = "AIServices"
  cognitive_account_sku  = "S0"

  # Entra-only auth & private network baseline required by HMCTS AI Gateway BYO.
  cognitive_account_local_auth_enabled                 = false
  public_network_access_cognitive                      = false
  cognitive_account_network_acls_default_action        = "Deny"
  cognitive_account_outbound_network_access_restricted = true

  cognitive_deployments = {
    (var.openai_deployment_name) = {
      model_name    = var.openai_model_name
      model_version = var.openai_model_version
      sku_name      = var.openai_sku_name
      sku_capacity  = var.openai_tpm_capacity
    }
  }
}

# The HMCTS AI Gateway APIM managed identity authenticates to this BYO backend
# (via the ai-backend-managed-identity policy fragment).
resource "azurerm_role_assignment" "ai_gateway_openai_user" {
  count                = var.enable_openai && var.ai_gateway_principal_id != "" ? 1 : 0
  scope                = module.openai_services[0].cognitive_account_id
  role_definition_name = "Cognitive Services User"
  principal_id         = var.ai_gateway_principal_id
}

resource "azurerm_key_vault_secret" "openai_endpoint" {
  count        = var.enable_openai ? 1 : 0
  name         = "azure-openai-endpoint"
  value        = one(module.openai_services[0].cognitive_account_endpoint)
  key_vault_id = module.et-key-vault.key_vault_id

  depends_on = [module.et-key-vault]
}

# Secondary Azure OpenAI (AIServices) in West Europe for models not yet available in UK South.
# This is temporary and is only going to be used for testing
module "openai_services_eu" {
  count  = var.enable_openai_eu ? 1 : 0
  source = "git@github.com:hmcts/terraform-module-ai-services?ref=main"

  providers = {
    azurerm.private_dns = azurerm
  }

  env         = var.env
  product     = var.product
  project     = "cft"
  component   = "openai-eu"
  common_tags = var.common_tags

  existing_resource_group_name    = azurerm_resource_group.rg.name
  existing_cognitive_account_name = "${var.product}-openai-eu-${var.env}"
  location                        = "westeurope"

  create_ai_foundry        = false
  create_storage_account   = false
  create_cognitive_account = true
  enable_managed_network   = false

  cognitive_account_kind = "AIServices"
  cognitive_account_sku  = "S0"

  cognitive_account_local_auth_enabled                 = false
  public_network_access_cognitive                      = false
  cognitive_account_network_acls_default_action        = "Deny"
  cognitive_account_outbound_network_access_restricted = true

  cognitive_deployments = {
    (var.openai_eu_deployment_name) = {
      model_name    = var.openai_eu_model_name
      model_version = var.openai_eu_model_version
      sku_name      = var.openai_eu_sku_name
      sku_capacity  = var.openai_eu_tpm_capacity
    }
  }
}

resource "azurerm_role_assignment" "ai_gateway_openai_eu_user" {
  count                = var.enable_openai_eu && var.ai_gateway_principal_id != "" ? 1 : 0
  scope                = module.openai_services_eu[0].cognitive_account_id
  role_definition_name = "Cognitive Services User"
  principal_id         = var.ai_gateway_principal_id
}

resource "azurerm_key_vault_secret" "openai_eu_endpoint" {
  count        = var.enable_openai_eu ? 1 : 0
  name         = "azure-openai-eu-endpoint"
  value        = one(module.openai_services_eu[0].cognitive_account_endpoint)
  key_vault_id = module.et-key-vault.key_vault_id

  depends_on = [module.et-key-vault]
}
