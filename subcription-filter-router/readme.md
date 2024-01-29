# On-Demand Server Router

This Terraform deployment sets up on AWS a subscription filter, and lambda function that will check which url is in the log entry, and start the corresponding ecs service.

## Pre-requisites

- AWS Account
- Terraform
- CloudWatch Log Group

## Helpful Items

- You can only have a maximum of 2 Subscription Filters per CloudWatch Log Group.  Hence my need for this.
- [AWS Filter Pattern Syntax Docs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html)

## Usage

1. Set the variables
1. Run `terraform init`
1. Run `terraform apply`

# Terraform generated docs

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.log_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.ecs_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Filter pattern for the log group | `string` | n/a | yes |
| <a name="input_service_mapping"></a> [service\_mapping](#input\_service\_mapping) | Mapping of services | <pre>map(object({<br>    cluster = string<br>    service = string<br>    region  = string<br>  }))</pre> | n/a | yes |
| <a name="input_source_log_group_name"></a> [source\_log\_group\_name](#input\_source\_log\_group\_name) | Name of the source log group | `string` | n/a | yes |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload | `string` | `"on-demand_server_router"` | no |

## Outputs

No outputs.
