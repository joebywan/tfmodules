resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${aws_lambda_function.ecs_lambda.function_name}"
    retention_in_days = 14
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
    name            = "${var.workload_name}-subscription-filter"
    log_group_name  = var.source_log_group_name
    filter_pattern  = var.filter_pattern
    destination_arn = aws_lambda_function.ecs_lambda.arn

    depends_on = [aws_lambda_permission.allow_cloudwatch_to_call_lambda]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.ecs_lambda.function_name
    principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
    source_arn    = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.source_log_group_name}:*"
}