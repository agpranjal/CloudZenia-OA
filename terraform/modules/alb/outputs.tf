output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_id" {
  description = "ID of the HTTPS listener"
  value       = aws_lb_listener.https.id
}

output "route53_record_fqdn" {
  description = "FQDN of the Route53 record pointing to the ALB"
  value       = var.domain_name != null && var.route53_zone_id != null ? aws_route53_record.alb[0].fqdn : null
}

output "route53_record_name" {
  description = "Name of the Route53 record"
  value       = var.domain_name != null && var.route53_zone_id != null ? aws_route53_record.alb[0].name : null
}

