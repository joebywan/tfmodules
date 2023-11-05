resource "aws_cloudwatch_event_rule" "resource_group_lifecycle" {
    name        = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-ResourceGroupLifecycle"
    description = "Capture lifecycle events from Resource Group"

    event_pattern = <<PATTERN
    {
        "source": ["aws.resource-groups"],
        "detail-type": ["ResourceGroups Group Membership Change"],
        "detail": {
            "group": {
                "arn": [
                    "${aws_resourcegroups_group.power_schedule_group.arn}"
                ]
            },
            "resources": 
                {
                    "membership-change": [
                        "add",
                        "remove"
                    ]
                }
        }
    }
    PATTERN
    }


    resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.resource_group_lifecycle.name
    target_id = "LambdaFunction"
    arn       = aws_lambda_function.update_schedule_function.arn
}