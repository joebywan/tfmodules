module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//auto_Remove_Full_Access_SCP"
  email_subscribers = "test@test.com"  # Variable optional
}