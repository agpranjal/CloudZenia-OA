# Route53 A Record for ec2-instance1.<domain_name> -> EC2 Instance 1
resource "aws_route53_record" "ec2_instance_1" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "ec2-instance1.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ec2_1.public_ip]
}

# Route53 A Record for ec2-docker1.<domain_name> -> EC2 Instance 1
resource "aws_route53_record" "ec2_docker_1" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "ec2-docker1.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ec2_1.public_ip]
}

# Route53 A Record for ec2-instance2.<domain_name> -> EC2 Instance 2
resource "aws_route53_record" "ec2_instance_2" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "ec2-instance2.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ec2_2.public_ip]
}

# Route53 A Record for ec2-docker2.<domain_name> -> EC2 Instance 2
resource "aws_route53_record" "ec2_docker_2" {
  count = var.domain_name != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "ec2-docker2.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ec2_2.public_ip]
}

