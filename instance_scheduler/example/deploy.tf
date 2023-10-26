# Example deployment of the 

module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//instance_scheduler"
  instance_ids_to_power_off = [  # Example instance id's.  REQUIRED
    "i-0123456789abcdef0",
    "i-0123456789abcdef1"
  ]
  start_schedule = "cron(0 9 ? * MON-FRI *)"  # This is the default setting, optionally required only if you'd like it different
  stop_schedule = "cron(0 17 ? * MON-FRI *)"  # This is the default setting, optionally required only if you'd like it different
  timezone = "Australia/Sydney"  # Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones.    # This is the default setting, optionally required only if you'd like it different
}