variable "role_to_assume" {
  description = "role arn for assume role"
  type        = string
}

variable "aws_account" {
  description = "aws account number to assume role into"
  type        = string
}