variable "route53_zone_id" {
  description = "Route53 zone ID"
  type        = string
  default     = "Z07540001AX4AZZUPCDUQ"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "agpranjal.site"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password"
  sensitive   = true
}