locals {
  mgmt_network_name    = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name = "aks-infra-cftptl-intsvc-rg"

  aks_env = var.env == "sandbox" ? "sbox" : var.env

  aat_cft_vnet_name           = "cft-aat-vnet"
  aat_cft_vnet_resource_group = "cft-aat-network-rg"

  app_aks_network_name    = "cft-${local.aks_env}-vnet"
  app_aks_network_rg_name = "cft-${local.aks_env}-network-rg"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_00" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_01" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider            = azurerm.aks
  name                = local.app_aks_network_name
  resource_group_name = local.app_aks_network_rg_name
}

data "azurerm_subnet" "app_aks_00_subnet" {
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_subnet" "app_aks_01_subnet" {
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_preview_vnet" {
  provider            = azurerm.aks-preview
  name                = "cft-preview-vnet"
  resource_group_name = "cft-preview-network-rg"
}

data "azurerm_subnet" "aks-00-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
}

data "azurerm_key_vault_secret" "caseDisposerAlertEmail" {
  depends_on   = [module.lau-vault]
  name         = "caseDisposerAlertEmail"
  key_vault_id = module.lau-vault.key_vault_id
}

data "azurerm_key_vault_secret" "caseDisposerSummaryEmail" {
  depends_on   = [module.lau-vault]
  name         = "caseDisposerSummaryEmail"
  key_vault_id = module.lau-vault.key_vault_id
}
