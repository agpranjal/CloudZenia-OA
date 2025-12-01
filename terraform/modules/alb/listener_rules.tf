# Route microservice.agpranjal.site to microservice target group
resource "aws_lb_listener_rule" "microservice" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.microservice.arn
  }

  condition {
    host_header {
      values = ["microservice.${var.domain_name}"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-microservice-listener-rule"
  })
}

# Route wordpress.agpranjal.site to wordpress target group
resource "aws_lb_listener_rule" "wordpress" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }

  condition {
    host_header {
      values = ["wordpress.${var.domain_name}"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-wordpress-listener-rule"
  })
}

