# Target Group for WordPress (Port 80)
resource "aws_lb_target_group" "wordpress" {
  name        = "${var.name_prefix}-wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.wordpress_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-wordpress-tg"
  })
}

# Target Group for Microservice (Port 3000)
resource "aws_lb_target_group" "microservice" {
  name        = "${var.name_prefix}-microservice-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.microservice_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-microservice-tg"
  })
}

# Target Group for Nginx (Port 80) - EC2 Instances
resource "aws_lb_target_group" "nginx" {
  name        = "${var.name_prefix}-nginx-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nginx-tg"
  })
}

# Target Group for Docker (Port 8080) - EC2 Instances
resource "aws_lb_target_group" "docker" {
  name        = "${var.name_prefix}-docker-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-docker-tg"
  })
}

# Target Group Attachments for Nginx
resource "aws_lb_target_group_attachment" "nginx_ec2_1" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = var.ec2_instance_ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "nginx_ec2_2" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = var.ec2_instance_ids[1]
  port             = 80
}

# Target Group Attachments for Docker
resource "aws_lb_target_group_attachment" "docker_ec2_1" {
  target_group_arn = aws_lb_target_group.docker.arn
  target_id        = var.ec2_instance_ids[0]
  port             = 8080
}

resource "aws_lb_target_group_attachment" "docker_ec2_2" {
  target_group_arn = aws_lb_target_group.docker.arn
  target_id        = var.ec2_instance_ids[1]
  port             = 8080
}

