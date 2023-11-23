import os
import boto3
import feedparser
from datetime import datetime
import time
import pytz

# Gets the timezone offset from a timezone name 
def get_timezone(timezone_name):
    return pytz.timezone(timezone_name)

def lambda_handler(event, context):
    # Retrieve environment variables
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    lambda_function_name = os.environ['LAMBDA_FUNCTION_NAME']
    rss_feed_urls = os.environ['RSS_FEED_URLS'].split(';')  # Assuming URLs are separated by ';'

    # Get the last sent item date from the environment variable
    last_sent_str = os.environ['LAST_CHECKED_DATE']
    last_sent_date = datetime.strptime(last_sent_str, '%Y-%m-%d')

    sns_client = boto3.client('sns')

    for rss_feed_url in rss_feed_urls:
        # start_time = time.time()
        feed = feedparser.parse(rss_feed_url)
        # end_time = time.time()
        # print(f"Feed {rss_feed_url} processed in {end_time - start_time} seconds.")
        
        new_items = []

        for item in feed.entries:
            item_date = datetime(*item.published_parsed[:6])
            if item_date > last_sent_date:
                item_details = f"{item.published} - {item.title}\n{item.description}\n{item.link}\n"
                separator = '-' * 40  # A line of dashes as a separator
                new_items.append(f"{item_details}\n{separator}\n")

        if new_items:
            message = ''.join(new_items)
            subject = f"New Item in {feed.feed.title}"

            # Check if the message size is within SNS's 256 KB limit
            if len(message.encode('utf-8')) < 256 * 1024:
                sns_client.publish(TopicArn=sns_topic_arn, Message=message, Subject=subject[:100])  # Subject limited to 100 characters
            else:
                # Send an alternate message
                alt_message = f"More new items than SNS allows, check the feed directly at {rss_feed_url}"
                sns_client.publish(TopicArn=sns_topic_arn, Message=alt_message, Subject="Feed Update Notification")


    # Update the LAST_CHECKED_DATE environment variable after processing all feeds
    lambda_client = boto3.client('lambda').update_function_configuration(
        FunctionName=lambda_function_name,
        Environment={
            'Variables': {
                'SNS_TOPIC_ARN': sns_topic_arn,
                'LAMBDA_FUNCTION_NAME': lambda_function_name,
                'RSS_FEED_URLS': os.environ['RSS_FEED_URLS'],
                'TIMEZONE_NAME': os.environ['TIMEZONE_NAME'],
                'LAST_CHECKED_DATE': datetime.now(get_timezone(os.environ['TIMEZONE_NAME'])).strftime('%Y-%m-%d')
            }
        }
    )
        
    return 'RSS items processed.'
