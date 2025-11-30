variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloudzenia-oa"
}

variable "domain_name" {
  description = "Domain name for the certificate (e.g., example.com or *.example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of subject alternative names (SANs) for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Certificate validation method - DNS or EMAIL"
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "Validation method must be either DNS or EMAIL."
  }
}

variable "validate_certificate" {
  description = "Whether to wait for certificate validation to complete"
  type        = bool
  default     = false
}

variable "use_route53_validation" {
  description = "Whether to use Route53 for DNS validation (requires route53_zone_id)"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS validation (required if use_route53_validation is true)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "CloudZenia-OA"
  }
}

