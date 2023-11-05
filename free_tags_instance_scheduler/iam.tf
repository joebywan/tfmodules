# Creates the role required for the schedules to work
resource "aws_iam_role" "ec2_schedule_role" {
    name               = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-ec2-schedule-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "scheduler.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_schedule_policy" {
    name   = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-ec2-schedule-policy"
    role   = aws_iam_role.ec2_schedule_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Lambda execution role + policy
resource "aws_iam_role" "lambda_execution_role" {
    name = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-lambda_execution_role"
  
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
    name   = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-lambda_execution_policy"
    role   = aws_iam_role.lambda_execution_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "resource-groups:GetGroupQuery",
                "resource-groups:SearchResources",
                "resource-groups:ListGroupResources",
                "events:PutRule",
                "events:PutTargets",
                "tag:GetResources",
                "cloudformation:DescribeStacks",
                "cloudformation:ListStackResources"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::722141136946:role/8pm_poweroff_stop-ec2-schedule-role",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "events.amazonaws.com",
                        "scheduler.amazonaws.com"
                    ]
                }
            }
        },
		{
		    "Action": [
		        "scheduler:GetSchedule",
		        "scheduler:UpdateSchedule"
		    ],
		    "Effect": "Allow",
		    "Resource": "*"
		}
    ]
}
EOF
}
