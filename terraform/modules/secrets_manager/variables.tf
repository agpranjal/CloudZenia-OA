variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloudzenia-oa"
}

variable "db_username" {
  description = "Database username"
  type        = string
  # default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "CloudZenia-OA"
  }
}

