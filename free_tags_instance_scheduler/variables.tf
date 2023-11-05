# -----------------------------------------------------------------------------
# Variables required for input
# -----------------------------------------------------------------------------

variable "deployment_name" {
    type = string
    description = "Name to use as a prefix on resources to avoid issues creating resources that already exist"
    default = ""
}

variable "schedule" {
    type = string
    default = "cron(0 9 ? * MON-FRI *)"
    description = "When to start the instances?  Defaults to 9am each weekday"
}

variable "timezone" {
    type = string
    default = "Australia/Sydney"
    description = "Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones"
}

variable "aws_profile" {
    type = string
    default = "default"
    description = "AWS Profile to use for authentication"
}

variable "aws_region" {
    type = string
    default = "ap-southeast-2"
    description = "AWS Region to deploy to"
}

variable "tag" {
    type = object({
        key   = string
        value = string
    })
    description = "Tag to look for when power scheduling instances"
}

variable "start_or_stop" {
    type = string
    description = "Start or stop the instances?"
}