variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances. If not provided, latest Amazon Linux 2 AMI will be used"
  type        = string
  default     = "ami-0ecb62995f68bb549" # Ubuntu 22.04 LTS
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair for SSH access. If not provided and public_key_path is set, a new key pair will be created"
  type        = string
  default     = null
}

variable "public_key_path" {
  description = "Path to the public key file. If provided, a new EC2 Key Pair will be created"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloudzenia-oa"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "CloudZenia-OA"
  }
}

variable "domain_name" {
  description = "Domain name for Route53 records"
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Route53 zone ID for creating DNS records"
  type        = string
  default     = null
}

