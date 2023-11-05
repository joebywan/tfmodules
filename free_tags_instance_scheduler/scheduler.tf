# -----------------------------------------------------------------------------
# Scheduler resources
# -----------------------------------------------------------------------------

# Organises the schedules to be created into a group
# resource "aws_scheduler_schedule_group" "instance-scheduler" {
#   name = "Instance_Scheduler"
# }

# Schedule for starting the instances.
resource "aws_scheduler_schedule" "schedule" {
    name                    = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-schedule"
    # group_name              = aws_scheduler_schedule_group.instance-scheduler.name
    schedule_expression_timezone = var.timezone
    schedule_expression     = var.schedule

    flexible_time_window {
        mode                = "OFF"
    }

    target {
        arn                 = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
        role_arn            = aws_iam_role.ec2_schedule_role.arn
        input               = jsonencode({
            InstanceIds      = []
        })
    }
}
