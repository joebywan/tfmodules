terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3"
    }
  }
}

# No role
provider "aws" {
  region  = "ap-southeast-2"
  profile = "default"
}

# Role
# provider "aws" {
#   region  = "ap-southeast-2"
#   profile = "default"
#   assume_role {
#     role_arn     = "arn:aws:iam::${var.aws_account}:role/${var.role_to_assume}"
#     session_name = "ec2tfmodule-role-assumed"
#   }
# }
