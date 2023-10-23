locals {
  org_id_root = data.aws_organizations_organization.org.roots[0].id
  org_id_security = one([for ou in data.aws_organizations_organizational_units.them.children :
    ou.id if ou.name == var.ou_name_security])
}

data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "them" {
  parent_id   = local.org_id_root
}

data "aws_organizations_organizational_unit_child_accounts" "root" {
  parent_id = local.org_id_root
}

data "aws_organizations_organizational_unit_child_accounts" "security" {
  parent_id = local.org_id_security
}

output "org_id_root" {
  value = local.org_id_root
}

output "account_id_root" {
  value = one([for account in data.aws_organizations_organizational_unit_child_accounts.root.accounts :
    account.id if account.name == var.account_name_root])
}

output "account_id_audit" {
  value = one([for account in data.aws_organizations_organizational_unit_child_accounts.security.accounts :
    account.id if account.name == var.account_name_audit])
}

output "account_id_log_archive" {
  value = one([for account in data.aws_organizations_organizational_unit_child_accounts.security.accounts :
    account.id if account.name == var.account_name_log_archive])
}

output "ou_id_security" {
  value = local.org_id_security
}
