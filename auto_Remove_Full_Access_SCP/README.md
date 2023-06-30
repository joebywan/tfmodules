# Auto-Remove-Full-Access-SCP Terraform Module

This repository contains the Terraform module for automatically removing the FullAWSAccess Service Control Policy (SCP) from newly created AWS accounts and replacing it with a NoPermissions SCP. It also sends a notification to an Amazon SNS topic when this event occurs.

The module creates an AWS Lambda function that's triggered by a CloudWatch Events rule. The rule is configured to fire on the `CreateAccountResult` event in AWS Organizations. When a new account is created and the event fires, the Lambda function checks if the `FullAWSAccess` SCP is attached to the account. If it is, the function replaces it with a `NoPermissions` SCP and sends a notification to an SNS topic.

## Requirements

- Terraform 0.12.x or newer
- AWS provider
- An AWS account with permissions to create and manage the necessary resources

## Usage

To use the module, add the following to your Terraform configuration:

```hcl
module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//auto_Remove_Full_Access_SCP"
  email_subscribers = "test@test.com"  # This variable is optional
}
```

The `source` argument tells Terraform where to find the module. Replace `test@test.com` with your email address to receive notifications. You can also provide a list of email addresses to subscribe multiple emails to the SNS topic.

After adding the module to your configuration, run `terraform init` to download the module. Once the module is downloaded, you can use `terraform apply` to create the resources.

## Optional Variables

- `email_subscribers`: A list of email addresses that will be subscribed to the SNS topic. If an email address is provided, it will receive a notification when the `FullAWSAccess` SCP is replaced. This variable is optional and the default is an empty list.

Please note that this module creates several resources in your AWS account and can incur costs. Always review and understand the resources that will be created before applying a Terraform configuration.

## Contributing

Contributions to this module are welcome. Please submit a pull request with any enhancements or fixes.

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Gotta credit Alan Jones (https://www.linkedin.com/in/alanjonesit/) for the zero permissions SCP, I just wrapped the automation around it