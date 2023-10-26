# -----------------------------------------------------------------------------
# Scheduler resources
# -----------------------------------------------------------------------------

# Organises the schedules to be created into a group
resource "aws_scheduler_schedule_group" "instance-scheduler" {
  name = "Instance_Scheduler"
}

# Schedule for starting the instances.
resource "aws_scheduler_schedule" "start_schedule" {
    name                    = "start-schedule"
    group_name              = aws_scheduler_schedule_group.instance-scheduler.name
    schedule_expression_timezone = var.timezone
    schedule_expression     = var.start_schedule

    flexible_time_window {
        mode                = "OFF"
    }

    target {
        arn                 = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
        role_arn            = aws_iam_role.ec2_schedule_role.arn
        input               = jsonencode({
            InstanceIds      = var.instance_ids_to_power_off
        })
    }
}

# Schedule for stopping the instances.
resource "aws_scheduler_schedule" "stop_schedule" {
    name                    = "stop-schedule"
    group_name              = "default"
    schedule_expression_timezone = var.timezone
    schedule_expression     = var.stop_schedule

    flexible_time_window {
        mode                = "OFF"
    }

    target {
        arn                 = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
        role_arn            = aws_iam_role.ec2_schedule_role.arn
        input               = jsonencode({
            InstanceIds      = var.instance_ids_to_power_off
        })
    }
}

# Now that the instances are being power scheduled, tag them so people know
resource "aws_ec2_tag" "tag_power_scheduled" {
  for_each = toset(var.instance_ids_to_power_off)

  resource_id = each.value
  key         = "power_scheduled"
  value       = "True"
}