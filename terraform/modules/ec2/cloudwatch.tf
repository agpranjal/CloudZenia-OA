# CloudWatch Log Group for NGINX access logs
resource "aws_cloudwatch_log_group" "nginx_access_logs" {
  name              = "/aws/ec2/${var.name_prefix}-nginx-access-logs"
  retention_in_days = 7

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nginx-access-logs"
  })
}

