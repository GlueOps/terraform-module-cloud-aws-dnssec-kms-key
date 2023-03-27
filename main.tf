data "aws_caller_identity" "current" {
  provider = aws.primary
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
  nullable    = false
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_kms_key" "primary" {
  provider                 = aws.primary
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 30
  key_usage                = "SIGN_VERIFY"
  multi_region             = true
  description              = "DNSSEC KMS Key"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
          "kms:Verify",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Resource = "*"
        Sid      = "Allow Route 53 DNSSEC Service",
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}
