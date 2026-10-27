provider "azurerm" {
  features {}
  alias           = "aks"
  subscription_id = var.aks_subscription_id
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}
