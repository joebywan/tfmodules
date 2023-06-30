#------------------------------------------------------------------------------
# Create a lambda function using the template_file above
#------------------------------------------------------------------------------
#Zip the rendered output above for use with the lambda
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "fullAccessSCPCheck.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "this" {
  # checkov:skip=CKV_AWS_115: Execution limit won't be an issue
  # checkov:skip=CKV_AWS_116: Doesn't require Dead Letter Queue
  # checkov:skip=CKV_AWS_117: Doesn't require VPC
  # checkov:skip=CKV_AWS_50: Not complex enough to require Xray
  # checkov:skip=CKV_AWS_173: Encryption not required for environment variable
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  function_name    = "fullAccessSCPCheckLambda"
  role             = aws_iam_role.lambda_execution_role.arn
  runtime          = "python3.9"
  handler          = "fullAccessSCPCheck.check_and_replace_scp"

  environment {
    variables = {
      sns_topic_arn    = aws_sns_topic.this.arn
      scp_to_check_for = "FullAWSAccess"
      scp_to_swap_with = aws_organizations_policy.no_permissions.id
    }
  }
}