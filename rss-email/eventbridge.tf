resource "aws_scheduler_schedule" "lambda_nightly_schedule" {
    name                         = "${var.name == "" ? "" : join("", [var.name, "_"])}nightly-lambda-schedule"
    schedule_expression          = var.schedule
    schedule_expression_timezone = var.timezone

    flexible_time_window {
        mode = "OFF"
    }

    target {
        arn      = aws_lambda_function.rss_lambda_function.arn
        role_arn = aws_iam_role.eventbridge_scheduler_role.arn
    }
}
