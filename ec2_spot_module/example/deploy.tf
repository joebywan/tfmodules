module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//ec2_spot_module"
  spot = false # Optional, defaults to false.
  security_group_rules = [
    {
      port = 80
      cidr = "0.0.0.0/0"
    },
    {
      port = 443
      cidr = "0.0.0.0/0"
    }
  ]
  ec2_key = var.ec2_key
  subnet_id = var.subnet_id
  vpc_id = var.vpc_id
  naming_prefix = var.naming_prefix
  tags = var.tags
  operating_system = var.operating_system # Currently supports AMAZONLINUX2 & UBUNTU
  userdata = var.userdata # Optional
  root_drive_size = var.root_drive_size # Optional, defaults to 8
  instance_type = var.instance_type # Optional, defaults to t2.micro
  instance_profile = var.instance_profile
  spot_type = var.spot_type # Optional, defaults to one-time, otherwise can use persistent
  spot_price = var.spot_price # Only required if spot = true.  Price to bid up to for instance
}
