variable "product" {
  default = "et"
}

variable "location" {
  default = "UK South"
}

variable "env" {
}

variable "subscription" {
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environment variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "common_tags" {
  type = map(string)
}

variable "managed_identity_object_id" {
  default = ""
}

variable "appinsights_location" {
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "aks_subscription_id" {}

variable "slack_alerts_principal_id" {
  description = "Managed identity principal ID of the slack alerts function app. Only needed in prod."
  type        = string
  default     = ""
}

### Azure Managed Redis

variable "managed_redis_sku_name" {
  default     = "Balanced_B0"
  description = "The SKU of the Managed Redis instance, as <Tier>_<Size>. Balanced_B0 is the smallest and is enough for a session store in non-prod."
}

variable "managed_redis_high_availability_enabled" {
  type        = bool
  default     = false
  description = "Whether the Managed Redis instance is replicated. Off in non-prod to match the single-node Basic C1 classic cache and keep the cost down. Changing this forces a new resource."
}

variable "managed_redis_rdb_backup_frequency" {
  type        = string
  default     = null
  description = "Frequency of Managed Redis RDB snapshots. Possible values are 1h, 6h and 12h; null disables persistence."
}

variable "private_dns_subscription_id" {
  default     = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  description = "Subscription holding the shared core-infra private DNS zones."
}

### Azure OpenAI (ET AI - BYO for HMCTS AI Gateway)

variable "enable_openai" {
  type        = bool
  default     = false
  description = "Whether to provision the Azure OpenAI (AIServices) resource in this environment."
}

variable "openai_deployment_name" {
  type        = string
  default     = "gpt-4.1-mini"
  description = "Deployment name for the Azure OpenAI model."
}

variable "openai_model_name" {
  type        = string
  default     = "gpt-4.1-mini"
  description = "Model name to deploy in Azure OpenAI / AIServices."
}

variable "openai_model_version" {
  type        = string
  default     = "2025-04-14"
  description = "Model version for the Azure OpenAI deployment."
}

variable "openai_sku_name" {
  type        = string
  default     = "Standard"
  description = "Deployment SKU (Standard keeps processing regional in UK South)."
}

variable "openai_tpm_capacity" {
  type        = number
  default     = 30
  description = "Deployment capacity in thousands of tokens per minute (TPM)."
}

variable "ai_gateway_principal_id" {
  type        = string
  default     = ""
  description = "Object ID of the HMCTS AI Gateway APIM managed identity granted Cognitive Services OpenAI User."
}

variable "enable_openai_eu" {
  type        = bool
  default     = false
  description = "Whether to provision the West Europe Azure OpenAI (AIServices) resource in this environment."
}

variable "openai_eu_deployment_name" {
  type        = string
  default     = "gpt-6.2-sol"
  description = "Deployment name for the West Europe Azure OpenAI model."
}

variable "openai_eu_model_name" {
  type        = string
  default     = "gpt-6.2-sol"
  description = "Model name to deploy in West Europe Azure OpenAI / AIServices."
}

variable "openai_eu_model_version" {
  type        = string
  default     = "2026-11-17"
  description = "Model version for the West Europe Azure OpenAI deployment."
}

variable "openai_eu_sku_name" {
  type        = string
  default     = "DataZoneStandard"
  description = "Deployment SKU (use Standard or DataZoneStandard to keep processing in EU)."
}

variable "openai_eu_tpm_capacity" {
  type        = number
  default     = 30
  description = "Deployment capacity in thousands of tokens per minute (TPM)."
}
