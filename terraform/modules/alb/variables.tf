variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloudzenia-oa"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the load balancer"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target groups"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name to associate with the ALB (e.g., agpranjal.site or www.agpranjal.site)"
  type        = string
  default     = null
}

variable "root_domain_name" {
  description = "Root domain name if different from domain_name (e.g., agpranjal.site when domain_name is www.agpranjal.site)"
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
  default     = null
}

variable "wordpress_health_check_path" {
  description = "Health check path for WordPress target group"
  type        = string
  default     = "/"
}

variable "microservice_health_check_path" {
  description = "Health check path for microservice target group"
  type        = string
  default     = "/"
}

variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to attach to target groups"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "CloudZenia-OA"
  }
}

