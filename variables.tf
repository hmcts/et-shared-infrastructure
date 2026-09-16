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

variable "family" {
  default     = "C"
  description = "The SKU family/pricing group to use. Valid values are `C` (for Basic/Standard SKU family) and `P` (for Premium). Use P for higher availability, but beware it costs a lot more."
}

variable "sku_name" {
  default     = "Basic"
  description = "The SKU of Redis to use. Possible values are `Basic`, `Standard` and `Premium`."
}

variable "capacity" {
  default     = "1"
  description = "The size of the Redis cache to deploy. Valid values are 1, 2, 3, 4, 5"
}

variable "rdb_backup_enabled" {
  type    = bool
  default = false
}

variable "rdb_backup_max_snapshot_count" {
  type        = string
  default     = "1"
  description = "The maximum number of snapshots to create as a backup. Only supported for Premium SKUs."
}

variable "redis_backup_frequency" {
  default     = "360"
  description = "The Backup Frequency in Minutes. Only supported on Premium SKUs. Possible values are: 15, 30, 60, 360, 720 and 1440"
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
