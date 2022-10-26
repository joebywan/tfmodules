variable "role_to_assume" {
  description = "role arn for assume role"
  type        = string
}

variable "aws_account" {
  description = "aws account number to assume role into"
  type        = string
}

variable "security_group_rules" {
  type = list(object({
    port = number
    cidr = string
  }))
  description = "Security group rules"
  default = [
    {
      port = 80
      cidr = "0.0.0.0/0"
    },
    {
      port = 443
      cidr = "0.0.0.0/0"
    }
  ]
}

variable "ec2_key" {
  description = "SSH Key"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "naming_prefix" {
  description = "Name for prefixing resources, should be something unique"
  type        = string
}

variable "tags" {
  description = "Additional tags to add to resources. Defaults to empty."
  type        = map(string)
  default     = {}
}

variable "operating_system" {
  type        = string
  description = "Which OS? AMAZONLINUX2 or UBUNTU"
}

variable "userdata" {
  type        = string
  description = "path to userdata file"
  nullable    = true
}

variable "root_drive_size" {
  type        = number
  description = "Size of the root drive."
}

variable "instance_type" {
  type        = string
  description = "Type of instance?  e.g. t3.micro."
}

variable "instance_profile" {
  type        = string
  description = "Name of the instance profile to use"
}

variable "spot_type" {
  type        = string
  description = "Valid options are one-time or persistent"
}

variable "spot_price" {
  type        = number
  description = "Price to bid for the instance."
}

variable "spot" {
  type    = bool
  default = false
}

variable "spot_instance_interruption_behaviour" {
  type        = string
  description = "Operation to take when the instance is interrupted.  Options are terminate, stop or hibernate."
  default     = "terminate"
  validation {
    condition     = anytrue([for a in ["stop", "terminate", "hibernate"] : var.spot_instance_interruption_behaviour == a])
    error_message = "Options are stop, terminate or hibernate."
  }
}