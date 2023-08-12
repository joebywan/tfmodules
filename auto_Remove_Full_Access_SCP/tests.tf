#------------------------------------------------------------------------------
# Check that the region being deployed in is us-east-1
#------------------------------------------------------------------------------
data "aws_region" "this" {}

variable "region" {
  type = string
  default = "us-east-1"
  validation {
    condition     = var.region == data.aws_region.this.name
    error_message = "The configured AWS region does not match the current region. Set the provider for this module to run in us-east-1"
  }
}

