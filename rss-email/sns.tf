resource "aws_sns_topic" "rss_sns_topic" {
  name = "${var.name == "" ? "" : join("", [var.name, "_"])}rss-sns-topic"
}

resource "aws_sns_topic_subscription" "rss_sns_topic_subscription" {
  count     = length(var.emails_to_subscribe)
  topic_arn = aws_sns_topic.rss_sns_topic.arn
  protocol  = "email"
  endpoint  = var.emails_to_subscribe[count.index]
}