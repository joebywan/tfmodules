## EC2 Outputs
output "ec2_tags" {
  value       = module.example.ec2_tags
  description = "Tags on the instance"
}

output "ec2_ip" {
  value       = module.example.ec2_ip
  description = "Public IP of the instance"
}

output "ec2_public_dns" {
  value       = module.example.ec2_public_dns
  description = "Public DNS of the instance"
}