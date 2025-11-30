# Secrets Manager Secret for RDS credentials
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.name_prefix}-rds-credentials"
  description = "RDS database credentials"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-credentials"
  })
}

# Secret Version with JSON string containing username and password
resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}