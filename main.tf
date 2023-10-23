module "org-data" {
  source  = "./modules/org-data"

  account_name_root                             = "Joseph Wright"
}

module "aft-account" {
  source  = "./modules/aft"

  account_email = "aws-org+aft-test@cloudboss.co"
}

module "aft" {
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.10.4"

  account_customizations_repo_name              = "rjosephwright/aft-account-customizations"
  account_provisioning_customizations_repo_name = "rjosephwright/aft-account-provisioning-customizations"
  account_request_repo_name                     = "rjosephwright/aft-account-request"
  aft_management_account_id                     = module.aft-account.account_id
  audit_account_id                              = module.org-data.account_id_audit
  cloudwatch_log_group_retention                = "14"
  ct_home_region                                = "us-east-1"
  ct_management_account_id                      = module.org-data.account_id_root
  log_archive_account_id                        = module.org-data.account_id_log_archive
  terraform_version                             = "1.6.1"
  aft_feature_delete_default_vpcs_enabled       = true
  vcs_provider                                  = "github"
  aft_metrics_reporting                         = false
}
