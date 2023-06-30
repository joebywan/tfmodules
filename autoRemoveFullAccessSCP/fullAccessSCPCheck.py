# Written by Joe Howe (https://github.com/joebywan/)

import boto3
import json
import os
import logging

# Create logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Create AWS Organizations client
org_client = boto3.client('organizations')

def check_and_replace_scp(event, context):
    # Log the received event
    logger.info('Received event: ' + json.dumps(event))

    # Initialise vars
    try:
        scp_to_check_for = os.environ["scp_to_check_for"]
        scp_to_swap_with = os.environ["scp_to_swap_with"]
        sns_topic_arn = os.environ["sns_topic_arn"]
    except KeyError as e:
        logger.error(f'Missing environment variable: {str(e)}')
        return {
            'statusCode': 500,
            'body': f'Missing environment variable: {str(e)}'
        }
    scpfound = False        # Variable used for logging logic further on
    account_id = event['detail']['serviceEventDetails']['createAccountStatus']['accountId']     # Get the account ID from the event
    logger.info('Processing account ID: ' + account_id)     # Log the account ID

    # Get all policies applied to the account
    policies = org_client.list_policies_for_target(
        TargetId=account_id,
        Filter='SERVICE_CONTROL_POLICY'
    )

    # Check over all of the attached policies for the FullAWSAccess SCP
    for policy_summary in policies['Policies']:
        if policy_summary['Name'] == os.environ["scp_to_check_for"]:
            logger.info('Found policy to replace: ' + policy_summary['Name'])       # Log policy found

            # If AWSFullAccess SCP is applied, add a DoesNothing SCP
            org_client.attach_policy(
                PolicyId=os.environ["scp_to_swap_with"], # replace with your DoesNothing SCP ID
                TargetId=account_id
            )

            # Remove the AWSFullAccess SCP
            org_client.detach_policy(
                PolicyId=policy_summary['Id'],
                TargetId=account_id
            )

            logger.info('Replaced policy: ' + policy_summary['Name'])       # Log policy replacement

            #Build the message to send to SNS
            message = {
                "default": json.dumps(event)
            }

            #Send the notification to the SNS topic
            boto3.client('sns').publish(
                TopicArn=os.environ["sns_topic_arn"],
                Message=json.dumps(message),
                Subject='CreateAccount event detected',
                MessageStructure='json'
            )

            scpfound = True     # Flag that the SCP switcheroo was completed
            break       # Break the loop as the AWSFullAccess SCP has been found and handled
    # For loop completed
    
    # Log whether SCP was found or not
    if not scpfound:
        logger.info('No FullAWSAccess SCP found')

    logger.info('Successfully processed account: ' + account_id)        # Log successful execution

    # Let Lambda know it's executed successfully
    return {
        'statusCode': 200,
        'body': f"Successfully processed account {account_id}"
    }
