output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

# WordPress Outputs
output "wordpress_service_id" {
  description = "ID of the WordPress ECS service"
  value       = aws_ecs_service.wordpress.id
}

output "wordpress_service_name" {
  description = "Name of the WordPress ECS service"
  value       = aws_ecs_service.wordpress.name
}

output "wordpress_task_definition_arn" {
  description = "ARN of the WordPress task definition"
  value       = aws_ecs_task_definition.wordpress.arn
}

output "wordpress_log_group_name" {
  description = "Name of the CloudWatch log group for WordPress"
  value       = aws_cloudwatch_log_group.wordpress.name
}

# Microservice Outputs
output "microservice_service_id" {
  description = "ID of the microservice ECS service"
  value       = aws_ecs_service.microservice.id
}

output "microservice_service_name" {
  description = "Name of the microservice ECS service"
  value       = aws_ecs_service.microservice.name
}

output "microservice_task_definition_arn" {
  description = "ARN of the microservice task definition"
  value       = aws_ecs_task_definition.microservice.arn
}

output "microservice_log_group_name" {
  description = "Name of the CloudWatch log group for microservice"
  value       = aws_cloudwatch_log_group.microservice.name
}
