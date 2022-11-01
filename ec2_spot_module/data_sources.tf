data "aws_ami" "amazon_linux_v2_ami" { # AMI for Amazon Linux 2
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu_linux_v2204_ami" { # AMI for ubuntu 22.04
  most_recent = true
  owners = ["099720109477"] # Canonical's AWS account

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/*22.04*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}