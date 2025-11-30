# Data source for ECS Task Execution Role Policy
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name_prefix}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-task-execution-role"
  })
}

# Attach AmazonECSTaskExecutionRolePolicy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name = "${var.name_prefix}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-task-role"
  })
}

# Inline policy for ECS Task Role to allow secretsmanager:GetSecretValue
resource "aws_iam_role_policy" "ecs_task_secrets" {
  name = "${var.name_prefix}-ecs-task-secrets-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

# Data source for CloudWatch Agent Server Policy
data "aws_iam_policy" "cloudwatch_agent_server" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# EC2 Role for CloudWatch Agent
resource "aws_iam_role" "ec2_cloudwatch" {
  name = "${var.name_prefix}-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-cloudwatch-role"
  })
}

# Attach CloudWatchAgentServerPolicy to EC2 Role
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_cloudwatch.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent_server.arn
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_cloudwatch" {
  name = "${var.name_prefix}-ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch.name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-cloudwatch-profile"
  })
}

