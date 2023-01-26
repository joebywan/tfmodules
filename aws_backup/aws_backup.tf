resource "aws_backup_vault" "example" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "example" {
  count = length(var.start_times)
  name = "BackupPlan-${var.start_times[count.index]}"
  backup_vault_name = aws_backup_vault.example.name

  rule {
    rule_name = "BackupRule-${var.start_times[count.index]}"
    schedule = "cron(0 0 */${var.start_times[count.index]} * ? *)"
    start_window = 1440
    completion_window = 1440
    lifecycle {
      delete_after = (var.start_times[count.index]*4)
    }
    selection {
      resources = ["AWS::EC2::Instance", "AWS::RDS::DBInstance"]
      tag_key = "backup"
      tag_value = "${var.start_times[count.index]}"
    }
  }

  notifications {
    backup_vault_events = ["BACKUP_JOB_FAILED"]
    sns_topic_arn = aws_sns_topic.example.arn
  }
}
