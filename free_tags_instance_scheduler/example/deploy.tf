# Example deployment of the scheduler

module "example" {
    source = "git::https://github.com/joebywan/tfmodules.git//free_tags_instance_scheduler"

    deployment_name = "8pm_poweroff"
    start_or_stop = "stop"
    schedule = "cron(0 20 ? * MON-FRI *)"  # This is the default setting, optionally required only if you'd like it different
    timezone = "Australia/Sydney"  # Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones.    # This is the default setting, optionally required only if you'd like it different
    tag = {
        key = "power_off"
        value = "8pmSydney"
    }
}