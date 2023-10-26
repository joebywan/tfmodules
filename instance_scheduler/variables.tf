# -----------------------------------------------------------------------------
# Variables required for input
# -----------------------------------------------------------------------------

variable "instance_ids_to_power_off" {
  type = list(string)
  description = "Provide a list of strings, each being an instance id to target with the power schedule"
}

variable "start_schedule" {
  type = string
  default = "cron(0 9 ? * MON-FRI *)"
  description = "When to start the instances?  Defaults to 9am each weekday"
}

variable "stop_schedule" {
  type = string
  default = "cron(0 17 ? * MON-FRI *)"
  description = "When to stop the instances?  Defaults to 5pm each weekday"
}

variable "timezone" {
  type = string
  default = "Australia/Sydney"
  description = "Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones"
}

