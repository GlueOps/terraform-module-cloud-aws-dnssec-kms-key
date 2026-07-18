terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.primary]
    }
  }
}

data "aws_caller_identity" "current" {
  provider = aws.primary
}

data "aws_region" "primary" {
  provider = aws.primary
}

variable "aws_account_id" {
  description = "DEPRECATED: no longer used. The aws.primary provider configuration is supplied by the caller now; this variable remains only so existing callers keep working."
  type        = string
  nullable    = true
  default     = null
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

  lifecycle {
    precondition {
      condition     = data.aws_region.primary.name == "us-east-1"
      error_message = "Route53 DNSSEC requires its KMS key in us-east-1. Pass an aws.primary provider configured for us-east-1."
    }
  }
}

output "kms_key_arn" {
  value = aws_kms_key.primary.arn
}
