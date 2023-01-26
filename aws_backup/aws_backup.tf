resource "aws_backup_vault" "backup_vault" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "plan" {
  count = length(var.days_between_execution)
  name = "BackupPlan_every_${var.days_between_execution[count.index]}_days"

  rule {
    rule_name = "${var.days_between_execution[count.index]}_days"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule = "cron(0 0 */${var.days_between_execution[count.index]} * ? *)"

    lifecycle {
      delete_after = var.days_between_execution[count.index] * 4
    }
  }
}

resource "aws_backup_selection" "example" {
  count = length(var.days_between_execution)
  name = "${var.days_between_execution[count.index]}_days"
  plan_id = aws_backup_plan.plan[count.index].id
  iam_role_arn = aws_iam_role.awsbackup_role.arn
  selection_tag {
    type = "STRINGEQUALS"
    key = "backup"
    value = "${var.days_between_executions[count.index]}"
  }
}

resource "aws_backup_vault_notifications" "failed_backups" {
  backup_vault_name = aws_backup_vault.backup_vault.name
  sns_topic_arn = aws_sns_topic.backup_notifications.arn
  backup_vault_events = ["BACKUP_JOB_FAILED"]
}