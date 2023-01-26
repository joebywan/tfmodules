module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//aws_backup"
  email_address = "joseph.d.howe@gmail.com"
  start_times = ["7","14","28"]
}