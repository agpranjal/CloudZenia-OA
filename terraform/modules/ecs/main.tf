# Data source for current region (shared by both services)
data "aws_region" "current" {}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-cluster"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cluster"
  })
}
