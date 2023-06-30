#------------------------------------------------------------------------------
#Lambda needs an execution role
#------------------------------------------------------------------------------
#Create the trust policy for lambda to assume the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Create the role, attaching the assume policy to it
resource "aws_iam_role" "lambda_execution_role" {
  name               = "fullAccessSCPCheckLambdaExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

#Policy allowing the lambda function to do what it needs to with organizations
resource "aws_iam_role_policy" "this" {
  name = "Lambda-modifySCP"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "organizations:DetachPolicy",
          "organizations:AttachPolicy",
          "organizations:ListPoliciesForTarget",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "sns:publish"
        ]
        Effect   = "Allow"
        Resource = "${aws_sns_topic.this.arn}"
      }
    ]
  })
}