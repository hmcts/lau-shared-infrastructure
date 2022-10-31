locals {
  alert_resource_group_name = "ccd-shared-${var.env}"
}

module "case-disposer-action-group" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = local.alert_resource_group_name
  action_group_name      = "${var.application_name}-${var.env}-ag"
  short_name             = "case-disposer-alert-${var.env}"
  email_receiver_name    = "Case Disposer Deletion Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.caseDisposerAlertEmail.value
}

module "case-disposer-deletion-failure-alert" {
  source                     = "git@github.com:hmcts/cnp-module-metric-alert"
  location                   = var.appinsights_location
  app_insights_name          = "ccd-${var.env}"
  alert_name                 = "${var.application_name}-${var.env}-failures-alert"
  alert_desc                 = "Alert when case disposer fail to delete case data"
  app_insights_query         = "traces | where message contains 'Case Disposer Deletion Summary' and message !contains 'Failed cases : 0'"
  custom_email_subject       = "Alert: Case disposer deletion failure"
  #run every 6 hrs for early alert
  frequency_in_minutes       = 360
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = 1440
  severity_level             = "2"
  action_group_name          = module.case-disposer-action-group.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.enable_alerts
  common_tags                = var.common_tags
}

