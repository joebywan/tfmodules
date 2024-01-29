resource "aws_iam_role" "lambda_role" {
    name = "${var.workload_name}_lambda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "A least privilege policy for lambda to interact with ECS and CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService"
        ],
        Resource = [
          for key, value in var.service_mapping : "arn:aws:ecs:${value.region}:${data.aws_caller_identity.current.account_id}:service/${value.cluster}/${value.service}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = aws_cloudwatch_log_group.lambda_log_group.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_policy.arn
}