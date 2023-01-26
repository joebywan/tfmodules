resource "aws_backup_vault" "backup_vault" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "plan" {
  count = length(var.start_times)
  name = "BackupPlan_every_${var.start_times[count.index]}_days"

  rule {
    rule_name = "${var.start_times[count.index]}_days"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule = "cron(0 0 */${var.start_times[count.index]} * ? *)"

    lifecycle {
      delete_after = var.start_times[count.index] * 4
    }
  }
}

resource "aws_backup_selection" "example" {
  count = length(var.start_times)
  name = "${var.start_times[count.index]}_days"
  plan_id = aws_backup_plan.plan[count.index].id
  iam_role_arn = aws_iam_role.awsbackup_role.arn
  selection_tag {
    type = "STRINGEQUALS"
    key = "backup"
    value = "7"
  }
}

resource "aws_backup_vault_notifications" "failed_backups" {
  backup_vault_name = aws_backup_vault.backup_vault.name
  sns_topic_arn = aws_sns_topic.backup_notifications.arn
  backup_vault_events = ["BACKUP_JOB_FAILED"]
}

#     notifications {
#     backup_vault_events = ["BACKUP_JOB_FAILED"]
#     sns_topic_arn = aws_sns_topic.example.arn
#   }
# }