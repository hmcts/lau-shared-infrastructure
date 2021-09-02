provider azurerm {
  features {}
}

locals {
  images = []
  tags = merge(var.common_tags, tomap({"Team Contact" = "#lau"}))
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags = var.common_tags
}

module "lau-vault" {
  source                     = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                       = "lau-${var.env}"
  product                    = var.product
  env                        = var.env
  tenant_id                  = var.tenant_id
  object_id                  = var.jenkins_AAD_objectId
  resource_group_name        = azurerm_resource_group.rg.name
  product_group_name         = "DTS LAU"
  common_tags                = var.common_tags
  create_managed_identity    = true
}

output "vaultName" {
  value = module.lau-vault.key_vault_name
}

