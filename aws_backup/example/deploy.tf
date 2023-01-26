module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//aws_backup"
  email_address = "joseph.d.howe@gmail.com"
  days_between_execution = ["7","14","28"]
}