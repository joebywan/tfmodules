## Requirements

No requirements.

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
| [aws_iam_role.eventbridge_scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eventbridge_scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.rss_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.feedparser_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_scheduler_schedule.lambda_nightly_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_sns_topic.rss_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.rss_sns_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [archive_file.lambda_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_emails_to_subscribe"></a> [emails\_to\_subscribe](#input\_emails\_to\_subscribe) | List the emails you want subscribed to the SNS topic. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"rssfeed-emailer"` | no |
| <a name="input_rssfeeds"></a> [rssfeeds](#input\_rssfeeds) | List of RSS feeds to monitor, delimit with ; | `list(string)` | <pre>[<br>  "https://airvpn.org/rss/1-airvpn-announcements.xml",<br>  "https://www.ozbargain.com.au/deals/feed",<br>  "https://www.topbargains.com.au/rss",<br>  "http://www.buckscoop.com.au/rss/deals"<br>]</pre> | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | When to start the instances?  Defaults to 9am each weekday | `string` | `"cron(59 23 * * ? *)"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones | `string` | `"Australia/Queensland"` | no |

## Outputs

No outputs.
