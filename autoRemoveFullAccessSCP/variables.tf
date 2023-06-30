# Variable to optionally provide email addresses for subscribing to the topic
variable "email_subscribers" {
  description = "List of email addresses to subscribe to the SNS topic"
  type        = list(string)
  default     = []
}