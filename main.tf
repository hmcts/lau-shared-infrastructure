provider "azurerm" {
  features {}
}

locals {
  images = []
  tags   = merge(var.common_tags, tomap({ "Team Contact" = "#lau" }))
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
}

module "lau-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "lau-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  jenkins_object_id       = data.azurerm_user_assigned_identity.jenkins.principal_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS LAU"
  common_tags             = var.common_tags
  create_managed_identity = true
}

data "azurerm_client_config" "current" {}

data "azurerm_user_assigned_identity" "jenkins_preview" {
  count               = var.env == "aat" ? 1 : 0
  name                = "jenkins-preview-mi"
  resource_group_name = "managed-identities-preview-rg"
}

resource "azurerm_key_vault_access_policy" "jenkins_preview" {
  count        = var.env == "aat" ? 1 : 0
  key_vault_id = module.lau-vault.key_vault_id
  object_id    = data.azurerm_user_assigned_identity.jenkins_preview[0].principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  key_permissions         = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
}

output "vaultName" {
  value = module.lau-vault.key_vault_name
}
