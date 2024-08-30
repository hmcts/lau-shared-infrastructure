locals {
  alert_resource_group_name = "ccd-shared-${var.env}"
}

module "case-disposer-action-group" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = local.alert_resource_group_name
  action_group_name      = "${var.application_name}-${var.env}-ag"
  short_name             = "dispr-alert"
  email_receiver_name    = "Case Disposer Deletion Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.caseDisposerAlertEmail.value
}

module "case-disposer-deletion-failure-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = var.location
  app_insights_name    = "ccd-${var.env}"
  alert_name           = "${var.application_name}-${var.env}-failures"
  alert_desc           = "Alert when case disposer fail to delete case data"
  app_insights_query   = "traces | where message contains 'Case Disposer Deletion Summary' and message !contains 'Failed cases : 0'"
  custom_email_subject = "Alert: Case disposer deletion failure in ccd-${var.env}"
  #run every 6 hrs for early alert
  frequency_in_minutes = "360"
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = "1440"
  severity_level             = "2"
  action_group_name          = module.case-disposer-action-group.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.enable_alerts
  common_tags                = var.common_tags
}

module "case-disposer-deletion-summary-action-group" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = local.alert_resource_group_name
  action_group_name      = "Case Disposer deletion Summary Slack Alert - ${var.env}"
  short_name             = "ccd-summary"
  email_receiver_name    = "Case Disposer deletion Summary Alert"
  email_receiver_address = data.azurerm_key_vault_secret.caseDisposerSummaryEmail.value
}

module "case-disposer-deletion-summary-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "ccd-${var.env}"
  alert_name           = "${var.application_name}-${var.env}-summary-alert"
  alert_desc           = "Alert when Case disposer deletion run and present summary"
  app_insights_query   = "traces | where message contains 'Case Disposer Deletion Summary'"
  custom_email_subject = "Alert: Case disposer deletion Summary in ccd-${var.env}"
  ##run every day as ccd case disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as ccd case disposer runs daily once
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.case-disposer-deletion-summary-action-group.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.enable_summary_alerts
  common_tags                = var.common_tags
}

