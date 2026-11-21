# Azure OpenAI (AIServices) for ET1 AI Vetting in UK South.
# Provisioned via hmcts/terraform-module-ai-services with Entra-only auth
# (local_auth_enabled = false), public network access disabled, and a Private
# Endpoint in the CFT AKS subscription's private-endpoints subnet.
#
# Note: Like hmcts/transcribe-shared-infrastructure, DNS A records in
# privatelink.cognitiveservices.azure.com (core-infra-intsvc-rg) are managed
# centrally via PR in hmcts/azure-private-dns using the openaiPrivateEndpointDns
# output from the apply log.

locals {
  aks_env                 = var.env == "sandbox" ? "sbox" : var.env
  cft_aks_network_name    = "cft-${local.aks_env}-vnet"
  cft_aks_network_rg_name = "cft-${local.aks_env}-network-rg"
}

module "openai_services" {
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

  # Entra-only auth (no API keys); AKS pods authenticate via Workload Identity.
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

data "azurerm_subnet" "cft_private_endpoints" {
  provider             = azurerm.private_endpoint
  name                 = "private-endpoints"
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name
}

resource "azurerm_private_endpoint" "openai" {
  provider            = azurerm.private_endpoint
  name                = "${var.product}-openai-${var.env}-pe"
  resource_group_name = local.cft_aks_network_rg_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.cft_private_endpoints.id
  tags                = var.common_tags

  private_service_connection {
    name                           = "${var.product}-openai-${var.env}-psc"
    is_manual_connection           = false
    private_connection_resource_id = module.openai_services.cognitive_account_id
    subresource_names              = ["account"]
  }

  depends_on = [module.openai_services]
}

resource "azurerm_role_assignment" "openai_user" {
  scope                = module.openai_services.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = one(module.et-key-vault.managed_identity_objectid)
}

resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "azure-openai-endpoint"
  value        = one(module.openai_services.cognitive_account_endpoint)
  key_vault_id = module.et-key-vault.key_vault_id

  depends_on = [module.et-key-vault]
}
