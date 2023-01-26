terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "default"
}