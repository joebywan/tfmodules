resource "aws_sns_topic" "example" {
  name = "BackupFailedNotifications"

  subscription {
    protocol = "email"
    endpoint = var.email_address
  }
}