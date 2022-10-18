module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//ec2_spot_module"
  spot = false # Optional, defaults to false.
  security_group_rules = [
    {
      port = 80
      cidr = 0.0.0.0/0
    },
    {
      port = 443
      cidr = 0.0.0.0/0
    }
  ]
  ec2_key = "testSSHkey"
  subnet_id = "id here"
  vpc_id = "id here"
  naming_prefix = "text to put at start of names"
  tags = {
    owner = "Dr Seuss"
  }
  operating_system = "AMAZONLINUX2" # Currently supports AMAZONLINUX2 & UBUNTU
  userdata = "./stuff.sh" # Optional
  root_drive_size = 20 # Optional, defaults to 8
  instance_type = "t3.xlarge" # Optional, defaults to t2.micro
  instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
  spot_type = "one-time" # Optional, defaults to one-time, otherwise can use persistent
  spot_price = 0.05 # Only required if spot = true.  Price to bid up to for instance
}
