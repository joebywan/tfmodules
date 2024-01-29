import json
import boto3
import gzip
import base64
import os

def load_service_mapping():
    """Load service mapping from environment variable."""
    service_mapping_json = os.environ.get('SERVICE_MAPPING', '{}')
    return json.loads(service_mapping_json)

def decode_cloudwatch_data(event):
    """Decode and decompress CloudWatch log data."""
    cloudwatch_data = base64.b64decode(event['awslogs']['data'])
    return json.loads(gzip.decompress(cloudwatch_data))

def get_ecs_client(region):
    """Get ECS client for specified region."""
    return boto3.client('ecs', region_name=region)

def update_ecs_service(cluster, service, region):
    """Update ECS service."""
    ecs_client = get_ecs_client(region)
    response = ecs_client.update_service(
        cluster=cluster,
        service=service,
        desiredCount=1
    )
    print(f"Started ECS service {service} in cluster {cluster} (Region: {region}): {response}")

def process_log_events(log_data, service_mapping):
    """Process each log event."""
    for log_event in log_data['logEvents']:
        extracted_fields = log_event.get('extractedFields', {})
        url = extracted_fields.get('url')
        if url:
            subdomain = url.split('.')[0]
            if subdomain in service_mapping:
                service_info = service_mapping[subdomain]
                cluster = service_info.get('cluster')
                service = service_info.get('service')
                region = service_info.get('region', 'ap-southeast-2')  # Default region if not specified
                update_ecs_service(cluster, service, region)
            else:
                print(f"No service mapping found for subdomain: {subdomain}")
        else:
            print("URL not found in the log event")

def lambda_handler(event, context):
    service_mapping = load_service_mapping()
    log_data = decode_cloudwatch_data(event)
    process_log_events(log_data, service_mapping)

    return {
        'statusCode': 200,
        'body': json.dumps('Log processed successfully')
    }
