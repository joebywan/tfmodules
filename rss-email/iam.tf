
# Lambda execution role
resource "aws_iam_role" "lambda_execution_role" {
    name = "${var.name == "" ? "" : join("", [var.name, "_"])}lambda_execution_role"

    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Action = "sts:AssumeRole",
                    Effect = "Allow",
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    },
                }
            ]
        }
    )
}

# Lambda execution role policy
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_execution_role.id

    policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Action = [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ],
                    Effect   = "Allow",
                    Resource = "arn:aws:logs:*:*:*"
                },
                {
                    Action = [
                        "sns:Publish"
                    ],
                    Effect   = "Allow",
                    Resource = aws_sns_topic.rss_sns_topic.arn # Specify your SNS topic ARN here for better security
                },
                {
                    Action = [
                        "lambda:UpdateFunctionConfiguration"
                    ],
                    Effect   = "Allow",
                    Resource = aws_lambda_function.rss_lambda_function.arn # Specify your Lambda function ARN here for better security
                }
            ]
        }
    )
}

# Eventbridge Scheduler role
resource "aws_iam_role" "eventbridge_scheduler_role" {
    name = "${var.name == "" ? "" : join("", [var.name, "_"])}eventbridge_scheduler_role"

    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Action = "sts:AssumeRole",
                    Effect = "Allow",
                    Principal = {
                        Service = "scheduler.amazonaws.com"
                    },
                }
            ]
        }
    )
}

# Eventbridge Scheduler policy
resource "aws_iam_role_policy" "eventbridge_scheduler_policy" {
    name = "eventbridge_scheduler_policy"
    role = aws_iam_role.eventbridge_scheduler_role.id

    policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Action   = "lambda:InvokeFunction",
                    Effect   = "Allow",
                    Resource = aws_lambda_function.rss_lambda_function.arn
                }
            ]
        }
    )
}
