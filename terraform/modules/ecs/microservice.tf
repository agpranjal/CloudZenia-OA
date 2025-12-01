# CloudWatch Log Group for Microservice
resource "aws_cloudwatch_log_group" "microservice" {
  name              = "/ecs/${var.name_prefix}-microservice"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-microservice-logs"
  })
}

# Microservice Task Definition
resource "aws_ecs_task_definition" "microservice" {
  family                   = "${var.name_prefix}-microservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.microservice_cpu
  memory                   = var.microservice_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "microservice"
      image     = var.microservice_image
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.microservice.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-microservice-task"
  })
}

# Microservice ECS Service
resource "aws_ecs_service" "microservice" {
  name            = "${var.name_prefix}-microservice-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.microservice.arn
  desired_count   = var.microservice_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.microservice_target_group_arn
    container_name   = "microservice"
    container_port   = 80
  }

  depends_on = [var.microservice_target_group_arn]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-microservice-service"
  })
}

# Auto Scaling Target for Microservice
resource "aws_appautoscaling_target" "microservice" {
  max_capacity       = var.microservice_max_capacity
  min_capacity       = var.microservice_min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.microservice.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling Policy for Microservice (CPU)
resource "aws_appautoscaling_policy" "microservice_cpu" {
  name               = "${var.name_prefix}-microservice-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.microservice.resource_id
  scalable_dimension = aws_appautoscaling_target.microservice.scalable_dimension
  service_namespace  = aws_appautoscaling_target.microservice.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.microservice_cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Auto Scaling Policy for Microservice (Memory)
resource "aws_appautoscaling_policy" "microservice_memory" {
  name               = "${var.name_prefix}-microservice-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.microservice.resource_id
  scalable_dimension = aws_appautoscaling_target.microservice.scalable_dimension
  service_namespace  = aws_appautoscaling_target.microservice.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.microservice_memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

