## TF Instance Scheduler using Eventbridge Scheduler

Created this for a way to deploy instance scheduling via Terraform, but also wanted to reduce the cost compared to the AWS Instance Scheduler stack.  Scheduler as at 26/10/23 is free for the first 14,000,000 events per month.  Compared to AWS Instance Scheduler being about $10/month.

## Usage

Use the example in ./example/deploy.tf, only required variables is instance_ids_to_power_off.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.tag_power_scheduled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_iam_role.ec2_schedule_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ec2_schedule_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_scheduler_schedule.start_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.stop_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule_group.instance-scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_ids_to_power_off"></a> [instance\_ids\_to\_power\_off](#input\_instance\_ids\_to\_power\_off) | Provide a list of strings, each being an instance id to target with the power schedule | `list(string)` | n/a | yes |
| <a name="input_start_schedule"></a> [start\_schedule](#input\_start\_schedule) | When to start the instances?  Defaults to 9am each weekday | `string` | `"cron(0 9 ? * MON-FRI *)"` | no |
| <a name="input_stop_schedule"></a> [stop\_schedule](#input\_stop\_schedule) | When to stop the instances?  Defaults to 5pm each weekday | `string` | `"cron(0 17 ? * MON-FRI *)"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones | `string` | `"Australia/Sydney"` | no |

## Outputs

No outputs.
