## EC2 Outputs
output "ec2_tags" {
  value       = [var.spot == true ? aws_spot_instance_request.ec2_instance[0].tags_all : aws_instance.ec2_instance[0].tags_all]
  description = "Tags on the instance"
}

output "ec2_ip" {
  value       = [var.spot == true ? aws_spot_instance_request.ec2_instance[0].public_ip : aws_instance.ec2_instance[0].public_ip]
  description = "Public IP of the instance"
}

output "ec2_public_dns" {
  value       = [var.spot == true ? aws_spot_instance_request.ec2_instance[0].public_dns : aws_instance.ec2_instance[0].public_dns]
  description = "Public DNS of the instance"
}

output "ec2_instance_id" {
  value = [var.spot == true ? aws_spot_instance_request.ec2_instance[0].spot_instance_id : aws_instance.ec2_instance[0].id]
}