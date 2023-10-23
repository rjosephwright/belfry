resource "aws_organizations_organization" "it" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  feature_set                   = "ALL"
}
