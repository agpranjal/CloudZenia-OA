# Data source to fetch secret from Secrets Manager
data "aws_secretsmanager_secret" "rds_credentials" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

# Parse the secret JSON to extract username and password
locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)
}

# DB Subnet Group using Private Subnets
resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-subnet-group"
  })
}

# RDS DB Instance (MySQL)
resource "aws_db_instance" "main" {
  identifier = "${var.name_prefix}-mysql-db"

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = local.db_credentials.username
  password = local.db_credentials.password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection = var.deletion_protection

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-mysql-db"
  })
}

