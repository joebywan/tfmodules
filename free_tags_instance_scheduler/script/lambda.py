import boto3
import json
import os

# Define the boto3 clients
scheduler_client = boto3.client("scheduler")
resource_groups_client = boto3.client("resource-groups")

def lambda_handler(event, context):
    # Get resources currently in the Resource Group
    response = resource_groups_client.list_group_resources(
        Group = os.environ["resource_group_arn"]
    )
    
    # Initialize an empty list to hold the instance IDs
    instance_ids = []

    # Iterate over each resource in the response
    for resource in response["Resources"]:
        resource_arn = resource["Identifier"]["ResourceArn"]    # Get the ResourceARN from the current resource
        arn_parts = resource_arn.split("/")    # Split the ResourceARN string by "/" to get a list of substrings
        instance_id = arn_parts[-1]    # Get the last substring from the list of substrings, which is the instance ID
        instance_ids.append(instance_id)    # Append the instance ID to the instance_ids list

    # Get the schedule's current settings
    existing_schedule = scheduler_client.get_schedule(
        Name="8pm_poweroff_stop-schedule"
    )
    # Testing
    # print("----- OUTPUT START -----")
    # print(existing_schedule)
    # print("----- OUTPUT END -----")
    
    
    # Update the schedule
    scheduler_client.update_schedule(
        Name = existing_schedule["Name"],  # The name of the schedule to update
        FlexibleTimeWindow = existing_schedule["FlexibleTimeWindow"],
        ScheduleExpression = existing_schedule["ScheduleExpression"],
        ScheduleExpressionTimezone = existing_schedule["ScheduleExpressionTimezone"],
        Target = {
            # "Id": "Instances",  # A unique identifier for this target
            "Arn": existing_schedule["Target"]["Arn"],
            "RoleArn": existing_schedule["Target"]["RoleArn"],
            "Input": json.dumps({"InstanceIds": instance_ids}),
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps("Successfully updated EventBridge Scheduler target with instance IDs")
    }
