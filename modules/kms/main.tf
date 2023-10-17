data "aws_caller_identity" "current" {}

resource "aws_kms_key" "it" {
  customer_master_key_spec  = "SYMMETRIC_DEFAULT"
  deletion_window_in_days   = 7
  key_usage                 = "ENCRYPT_DECRYPT"
  multi_region              = false
}

resource "aws_kms_alias" "it" {
  name                      = "alias/${var.stack_key}"
  target_key_id             = aws_kms_key.it.key_id
}

resource "aws_kms_key_policy" "it" {
  key_id                    = aws_kms_key.it.key_id
  policy                    = jsonencode({
    Version                 = "2012-10-17"
    Statement               = [
      {
	Sid                 = "Enable IAM User Permissions"
	Effect              = "Allow"
	Principal           = {
	  AWS               = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
	}
	Action              = "kms:*"
	Resource            = "*"
      },
      {
	Sid                 = "Allow Config to use KMS for encryption"
	Effect              = "Allow"
	Principal           = {
	  Service           = "config.amazonaws.com"
	}
	Action              = [
	  "kms:Decrypt",
	  "kms:GenerateDataKey",
	]
	Resource            = aws_kms_key.it.arn
      },
      {
	Sid                 = "Allow CloudTrail to use KMS for encryption"
	Effect              = "Allow"
	Principal           = {
	  Service           = "cloudtrail.amazonaws.com"
	}
	Action              = [
	  "kms:GenerateDataKey*",
	  "kms:Decrypt",
	]
	Resource            = aws_kms_key.it.arn
	Condition           = {
	  StringEquals      = {
	    "aws:SourceArn" = "arn:aws:cloudtrail:${var.home_region}:${data.aws_caller_identity.current.account_id}:trail/${var.stack_key}"
	  }
	  StringLike        = {
	    "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
	  }
	}
      },
    ]
  })
}
