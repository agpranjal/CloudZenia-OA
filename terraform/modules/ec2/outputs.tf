output "ec2_instance_1_id" {
  description = "ID of the first EC2 instance"
  value       = aws_instance.ec2_1.id
}

output "ec2_instance_2_id" {
  description = "ID of the second EC2 instance"
  value       = aws_instance.ec2_2.id
}

output "ec2_instance_1_private_ip" {
  description = "Private IP address of the first EC2 instance"
  value       = aws_instance.ec2_1.private_ip
}

output "ec2_instance_2_private_ip" {
  description = "Private IP address of the second EC2 instance"
  value       = aws_instance.ec2_2.private_ip
}

output "ec2_instance_1_public_ip" {
  description = "Public IP address (Elastic IP) of the first EC2 instance"
  value       = aws_eip.ec2_1.public_ip
}

output "ec2_instance_2_public_ip" {
  description = "Public IP address (Elastic IP) of the second EC2 instance"
  value       = aws_eip.ec2_2.public_ip
}

output "ec2_instance_1_eip_id" {
  description = "Elastic IP allocation ID for the first EC2 instance"
  value       = aws_eip.ec2_1.id
}

output "ec2_instance_2_eip_id" {
  description = "Elastic IP allocation ID for the second EC2 instance"
  value       = aws_eip.ec2_2.id
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for NGINX access logs"
  value       = aws_cloudwatch_log_group.nginx_access_logs.name
}

