provider "azurerm" {
  version = "1.23.0"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#ethos-repl-service")
    )}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"
  tags = "${local.tags}"
}
