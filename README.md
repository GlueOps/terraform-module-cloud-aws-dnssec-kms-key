# terraform-module-cloud-aws-dnssec-kms-key
<!-- BEGIN_TF_DOCS -->

This Terraform module creates an AWS KMS key in us-east-1 to be used by Route53 DNSSEC.

Note: This is regional to us-east-1 only.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
<!-- END_TF_DOCS -->