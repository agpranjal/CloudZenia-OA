variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloudzenia-oa"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret for database password"
  type        = string
}

variable "db_host" {
  description = "Database host address"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "wordpress_target_group_arn" {
  description = "ARN of the ALB target group for WordPress"
  type        = string
}

variable "microservice_target_group_arn" {
  description = "ARN of the ALB target group for microservice"
  type        = string
}

variable "wordpress_image" {
  description = "Container image for WordPress"
  type        = string
}

variable "microservice_image" {
  description = "Container image for microservice"
  type        = string
}

variable "wordpress_cpu" {
  description = "CPU units for WordPress task (256, 512, 1024, etc.)"
  type        = number
  default     = 512
}

variable "wordpress_memory" {
  description = "Memory for WordPress task in MB"
  type        = number
  default     = 1024
}

variable "microservice_cpu" {
  description = "CPU units for microservice task (256, 512, 1024, etc.)"
  type        = number
  default     = 256
}

variable "microservice_memory" {
  description = "Memory for microservice task in MB"
  type        = number
  default     = 512
}

variable "wordpress_desired_count" {
  description = "Desired number of WordPress tasks"
  type        = number
  default     = 1
}

variable "microservice_desired_count" {
  description = "Desired number of microservice tasks"
  type        = number
  default     = 1
}

variable "wordpress_min_capacity" {
  description = "Minimum number of WordPress tasks"
  type        = number
  default     = 1
}

variable "wordpress_max_capacity" {
  description = "Maximum number of WordPress tasks"
  type        = number
  default     = 10
}

variable "microservice_min_capacity" {
  description = "Minimum number of microservice tasks"
  type        = number
  default     = 1
}

variable "microservice_max_capacity" {
  description = "Maximum number of microservice tasks"
  type        = number
  default     = 10
}

variable "wordpress_cpu_target_value" {
  description = "Target CPU utilization percentage for WordPress auto-scaling"
  type        = number
  default     = 70.0
}

variable "wordpress_memory_target_value" {
  description = "Target memory utilization percentage for WordPress auto-scaling"
  type        = number
  default     = 80.0
}

variable "microservice_cpu_target_value" {
  description = "Target CPU utilization percentage for microservice auto-scaling"
  type        = number
  default     = 70.0
}

variable "microservice_memory_target_value" {
  description = "Target memory utilization percentage for microservice auto-scaling"
  type        = number
  default     = 80.0
}

variable "scale_in_cooldown" {
  description = "Cooldown period for scale-in actions in seconds"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Cooldown period for scale-out actions in seconds"
  type        = number
  default     = 60
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "CloudZenia-OA"
  }
}

