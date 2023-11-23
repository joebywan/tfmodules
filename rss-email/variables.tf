variable "name" {
  type    = string
  default = "rssfeed-emailer"
}

variable "schedule" {
  type        = string
  default     = "cron(59 23 * * ? *)"
  description = "When to start the instances?  Defaults to 9am each weekday"
}

variable "timezone" {
  type        = string
  default     = "Australia/Queensland"
  description = "Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for a full list of timezones"
}

variable "rssfeeds" {
  type        = list(string)
  description = "List of RSS feeds to monitor, delimit with ;"
  default = [
    "https://airvpn.org/rss/1-airvpn-announcements.xml",
    "https://www.ozbargain.com.au/deals/feed",
    "https://www.topbargains.com.au/rss",
    "http://www.buckscoop.com.au/rss/deals"
  ]
}

variable "emails_to_subscribe" {
  type        = list(string)
  description = "List the emails you want subscribed to the SNS topic."
  default     = []
}

locals {
  rss_feed_urls        = join(";", var.rssfeeds)
  lambda_function_name = "${var.name == "" ? "" : join("", [var.name, "_"])}rss_lambda_function"
}