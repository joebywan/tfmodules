# TF Instance Scheduler using Eventbridge Scheduler with Tag based power scheduling

Created this for a way to deploy instance scheduling via Terraform, but also wanted to reduce the cost compared to the AWS Instance Scheduler stack.  Scheduler as at 26/10/23 is free for the first 14,000,000 events per month.  Compared to AWS Instance Scheduler being about $10/month.

My first iteration was setting it by instance id in the tf code, or in the scheduler console.

This one uses Lambda to bridge Tag based Resource Groups via Group Lifecycle Events to the Eventbridge Scheduler.  So add or remove a tag on an instance, Eventbridge will trigger the Lambda function to update the Eventbridge Scheduler's list of Instance id's.

## Usage

Checkout the example in ./example/deploy.tf

Keep in mind there is a null resource in resource_groups.tf for enabling Group Lifecycle Events.  It looks like the TF AWS provider doesn't support enabling it, so I had to use the local-exec.  Make sure it's got the profile you want to run it.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.resource_group_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.ec2_schedule_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ec2_schedule_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.update_schedule_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_resourcegroups_group.power_schedule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_scheduler_schedule.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [null_resource.enable_resource_groups_group_lifecycle_events](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Profile to use for authentication | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy to | `string` | `"ap-southeast-2"` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Name to use as a prefix on resources to avoid issues creating resources that already exist | `string` | `""` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | When to start the instances?  Defaults to 9am each weekday | `string` | `"cron(0 9 ? * MON-FRI *)"` | no |
| <a name="input_start_or_stop"></a> [start\_or\_stop](#input\_start\_or\_stop) | Start or stop the instances? | `string` | n/a | yes |
| <a name="input_tag"></a> [tag](#input\_tag) | Tag to look for when power scheduling instances | <pre>object({<br>        key   = string<br>        value = string<br>    })</pre> | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones | `string` | `"Australia/Sydney"` | no |

## Outputs

No outputs.