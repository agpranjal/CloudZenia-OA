output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_task.arn
}

output "ec2_cloudwatch_role_arn" {
  description = "ARN of the EC2 CloudWatch Role"
  value       = aws_iam_role.ec2_cloudwatch.arn
}

output "ec2_instance_profile_arn" {
  description = "ARN of the EC2 Instance Profile"
  value       = aws_iam_instance_profile.ec2_cloudwatch.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 Instance Profile"
  value       = aws_iam_instance_profile.ec2_cloudwatch.name
}

output "role_arns" {
  description = "Map of all IAM Role ARNs"
  value = {
    ecs_task_execution = aws_iam_role.ecs_task_execution.arn
    ecs_task           = aws_iam_role.ecs_task.arn
    ec2_cloudwatch     = aws_iam_role.ec2_cloudwatch.arn
  }
}

