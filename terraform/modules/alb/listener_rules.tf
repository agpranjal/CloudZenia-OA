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

# Route ec2-alb-instance.<domain_name> to nginx target group
resource "aws_lb_listener_rule" "nginx" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  condition {
    host_header {
      values = ["ec2-alb-instance.${var.domain_name}"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nginx-listener-rule"
  })
}

# Route ec2-alb-docker.<domain_name> to docker target group
resource "aws_lb_listener_rule" "docker" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 400

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker.arn
  }

  condition {
    host_header {
      values = ["ec2-alb-docker.${var.domain_name}"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-docker-listener-rule"
  })
}

