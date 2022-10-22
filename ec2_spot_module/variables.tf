variable "spot" {
  type = bool
  description = "Is this to be a spot instance? True/False."
  default = false
}

variable "security_group_rules" {
  type = list(object({
    port = number
    cidr = string
  }))
  description = "Security group rules"
  default = [
    {
      port=80
      cidr="0.0.0.0/0"
    },
    {
      port=443
      cidr="0.0.0.0/0"
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
  description = "Amazon Linux 2 or Ubuntu"
  type = string
  validation {
    condition = anytrue([for a in ["AMAZONLINUX2","UBUNTU"] : var.operating_system == a])
    error_message = "Operating System can only be AMAZONLINUX2 or UBUNTU."
  }
}

locals {
  amazon_linux_2 = var.operating_system == "AMAZONLINUX2" ? data.aws_ami.amazon_linux_v2_ami.id : ""
  ubuntu_2204 = var.operating_system == "UBUNTU" ? data.aws_ami.ubuntu_linux_v2204_ami.id : ""
  ami_to_use = coalesce(local.amazon_linux_2,local.ubuntu_2204)
}

variable "userdata_filepath" {
  type = string
  description = "Userdata file to use"
  default = "file(./blank_userdata.sh)"
}

locals {
  userdata = file(var.userdata_filepath)
}

variable "root_drive_size" {
  type = number
  description = "Size in GB for the root volume. Defaults to 8GB"
  default = 8
}

variable "instance_type" {
  type = string
  description = "Instance type & size.  E.g. t2.micro"
  default = "t2.micro"
}

variable "instance_profile" {
  type = string
  description = "Instance profile to use."
  # default = "AmazonSSMRoleForInstancesQuickSetup"
}

variable "spot_type" {
  type = string
  description = "Spot type to use.  This governs the spot request behaviour on instance termination.  Options are persistent (spot request stays open) or one-time (spot request is closed)."
  default = "one-time"
  validation {
    condition = anytrue([for a in ["one-time","persistent"] : var.spot_type == a])
    error_message = "Options are one-time or persistent."
  }
}

variable "spot_price" {
  type = number
  description = "Max spot price to bid.  Be aware instance will be interrupted if the current price goes over this"
  nullable = true
}

variable "spot_instance_interruption_behaviour" {
  type = string
  description = "Operation to take when the instance is interrupted.  Options are terminate, stop or hibernate."
  default = "terminate"
  validation {
    condition = anytrue([for a in ["stop","terminate","hibernate"] : var.spot_instance_interruption_behaviour == a])
    error_message = "Options are stop, terminate or hibernate."
  }
}