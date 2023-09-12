module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  env                 = var.env
  common_tags         = var.common_tags
  zone_redundant      = var.servicebus_zone_redundant #currently unused, we don't think we need redundancy currently but could change.
  sku                 = var.servicebus_sku
}

moved {
  from = module.servicebus-namespace-premium
  to   = module.servicebus-namespace
}
