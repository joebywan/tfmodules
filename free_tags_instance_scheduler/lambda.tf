# Lambda function itself
data "archive_file" "lambda" {
    type = "zip"
    source_file = "${path.module}/script/lambda.py"
    output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "update_schedule_function" {
    filename      = "${path.module}/lambda_function_payload.zip"
    function_name = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-update_schedule_function"
    role          = aws_iam_role.lambda_execution_role.arn
    handler       = "lambda.lambda_handler"
    runtime       = "python3.10"

    source_code_hash = data.archive_file.lambda.output_base64sha256
    environment {
        variables = {
            role_arn = aws_iam_role.ec2_schedule_role.arn
            scheduler = aws_scheduler_schedule.schedule.arn
            resource_group_arn = aws_resourcegroups_group.power_schedule_group.arn
            scheduler_target = local.scheduler_target
        }
    }
}

# Allow Lambda to be executed by Eventbridge
resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.update_schedule_function.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.resource_group_lifecycle.arn
}