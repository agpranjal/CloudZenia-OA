output "alb_security_group_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ID of the ECS/EC2 Security Group"
  value       = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  description = "ID of the RDS Security Group"
  value       = aws_security_group.rds.id
}

output "security_group_ids" {
  description = "Map of all Security Group IDs"
  value = {
    alb = aws_security_group.alb.id
    ecs = aws_security_group.ecs.id
    rds = aws_security_group.rds.id
  }
}

