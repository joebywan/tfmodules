#------------------------------------------------------------------------------
# Create SNS topic to send notifications to
#------------------------------------------------------------------------------
resource "aws_sns_topic" "this" {
  name              = "fullAccessSCPNotification"
  kms_master_key_id = "alias/aws/sns"
}

# Create the subscriptions if the variable was populated
resource "aws_sns_topic_subscription" "this" {
  count     = length(var.email_subscribers)
  endpoint  = var.email_subscribers[count.index]
  protocol  = "email"
  topic_arn = aws_sns_topic.this.arn
}