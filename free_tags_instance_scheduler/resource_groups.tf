

resource "null_resource" "enable_resource_groups_group_lifecycle_events" {
    provisioner "local-exec" {
        command = "aws resource-groups update-account-settings --group-lifecycle-events-desired-status ACTIVE"
        environment = {
            AWS_PROFILE = var.aws_profile
        }
    }

    # provisioner "local-exec" {
    #     when = destroy
    #     command = "aws resource-groups update-account-settings --group-lifecycle-events-desired-status INACTIVE"
    #     environment = {
    #         AWS_PROFILE = var.aws_profile
    #     }
    # }
}

resource "aws_resourcegroups_group" "power_schedule_group" {
    depends_on = [
        null_resource.enable_resource_groups_group_lifecycle_events
    ]
    name = "${var.deployment_name == "" ? "" : join("",[var.deployment_name,"_"])}${var.start_or_stop}-PowerScheduleGroup"
    resource_query {
        query = <<JSON
{
    "ResourceTypeFilters": ["AWS::EC2::Instance"],
    "TagFilters": [
        {
            "Key": "${var.tag.key}",
            "Values": ["${var.tag.value}"]
        }
    ]
}
JSON
    }
}
