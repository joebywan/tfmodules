#------------------------------------------------------------------------------
#Create the eventbridge rule, and set the lambda as the eventbridge target
#------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "create_account_event" {
  name        = "CreateAccountResultEvent"
  description = "Fires when a CreateAccount event occurs in AWS Organizations"

  event_pattern = <<PATTERN
    {
        "source": [
            "aws.organizations"
        ],
        "detail": {
            "eventName": [
                "CreateAccountResult"
            ]
        }
    }
    PATTERN
}

resource "aws_cloudwatch_event_target" "create_account_event_target" {
  rule      = aws_cloudwatch_event_rule.create_account_event.name
  target_id = "check_and_replace_scp"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.create_account_event.arn
}