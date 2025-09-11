variable "product" {
  default = "et"
}

variable "servicebus_sku" {
  default = "Standard"
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

variable "queue_max_delivery_count" {
  default     = "10"
  description = "Queue message max delivery counter. Extracted to variable so it can be assigned to application environment."
}

variable "aks_subscription_id" {}