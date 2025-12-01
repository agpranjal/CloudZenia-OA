# CloudWatch Log Group for WordPress
resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "/ecs/${var.name_prefix}-wordpress"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-wordpress-logs"
  })
}

# WordPress Task Definition
resource "aws_ecs_task_definition" "wordpress" {
  family                   = "${var.name_prefix}-wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.wordpress_cpu
  memory                   = var.wordpress_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = var.wordpress_image
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = var.db_host
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = var.db_username
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = var.db_name
        }
      ]

      secrets = [
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "${var.secret_arn}:password::"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.wordpress.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-wordpress-task"
  })
}

# WordPress ECS Service
resource "aws_ecs_service" "wordpress" {
  name            = "${var.name_prefix}-wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = var.wordpress_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.wordpress_target_group_arn
    container_name   = "wordpress"
    container_port   = 80
  }

  depends_on = [var.wordpress_target_group_arn]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-wordpress-service"
  })
}

# Auto Scaling Target for WordPress
resource "aws_appautoscaling_target" "wordpress" {
  max_capacity       = var.wordpress_max_capacity
  min_capacity       = var.wordpress_min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.wordpress.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling Policy for WordPress (CPU)
resource "aws_appautoscaling_policy" "wordpress_cpu" {
  name               = "${var.name_prefix}-wordpress-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.wordpress.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.wordpress_cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Auto Scaling Policy for WordPress (Memory)
resource "aws_appautoscaling_policy" "wordpress_memory" {
  name               = "${var.name_prefix}-wordpress-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.wordpress.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.wordpress_memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

