# Route53 A Record (Alias) pointing domain to ALB
resource "aws_route53_record" "alb" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# Route53 A Record for wildcard subdomains (*.domain_name) pointing to ALB
resource "aws_route53_record" "alb_wildcard" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# Route53 A Record for root domain (if different from subdomain)
resource "aws_route53_record" "alb_root" {
  count = var.root_domain_name != null && var.route53_zone_id != null && var.root_domain_name != var.domain_name ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.root_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}