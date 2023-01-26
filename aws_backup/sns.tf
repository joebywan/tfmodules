resource "aws_sns_topic" "backup_notifications" {
  name = "BackupFailedNotifications"

  subscription {
    protocol = "email"
    endpoint = var.email_address
  }
}

data "aws_iam_policy_document" "awsbackup_to_sns" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.test.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn    = aws_sns_topic.backup_notifications.arn
  policy = data.aws_iam_policy_document.awsbackup_to_sns.json
}