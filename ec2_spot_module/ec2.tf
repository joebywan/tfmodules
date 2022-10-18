# Spot request for the instance considering it's just a throwaway?
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request
# https://aws.amazon.com/ec2/spot/pricing/
# https://aws.amazon.com/ec2/pricing/on-demand/

resource "aws_spot_instance_request" "ec2_instance" {
  count = var.spot ? 1 : 0
  ami                    = local.ami_to_use
  instance_type          = var.instance_type
  key_name               = var.ec2_key
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = var.subnet_id
  user_data              = file(var.userdata)

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_drive_size
  }

  tags = merge({ Name = "${var.naming_prefix}-${var.operating_system}" }, var.tags)

  # Spot specific settings
  spot_type = var.spot_type
  spot_price = tostring(var.spot_price)
  # wait_for_fulfillment = false
  # block_duration_minutes = 60
  # launch_group = "specify here"
  # valid_from = "YYYY-MM-DDTHH:MM:SSZ"
  # valid_to = "YYYY-MM-DDTHH:MM:SSZ"
}

resource "aws_instance" "ec2_instance" {
  count = var.spot != true ? 1 : 0
  ami                    = local.ami_to_use
  instance_type          = var.instance_type
  key_name               = var.ec2_key
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = var.subnet_id
  user_data              = file(var.userdata)

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_drive_size
  }

  tags = merge({ Name = "${var.naming_prefix}-${var.operating_system}" }, var.tags)
}
