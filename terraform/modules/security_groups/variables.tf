variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
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

