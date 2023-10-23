locals {
  account_id_root = data.aws_organizations_organization.org.roots[0].id
}

data "aws_organizations_organization" "org" {}

resource "aws_organizations_organizational_unit" "mgmt" {
  name        = "Mgmt"
  parent_id   = local.account_id_root
}

resource "aws_organizations_account" "aft" {
  name  = "AFT-Test"
  email = var.account_email
  parent_id = aws_organizations_organizational_unit.mgmt.id
}

output "account_id" {
  value = aws_organizations_account.aft.id
}
