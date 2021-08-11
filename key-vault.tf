module "lau-vault" {
  source                     = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                       = "lau-${var.env}"
  product                    = var.product
  env                        = var.env
  tenant_id                  = var.tenant_id
  object_id                  = var.jenkins_AAD_objectId
  resource_group_name        = azurerm_resource_group.rg.name

  # dcd_group_lau_v2 group object ID
  product_group_object_id    = "20f0f9b1-1953-43c0-9e68-91d6674a6acc"
  common_tags                = var.common_tags
  create_managed_identity    = true
}

data "azurerm_key_vault" "lau_key_vault" {
  name                = "lau-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
}

output "vaultName" {
  value = module.lau-vault.key_vault_name
}
