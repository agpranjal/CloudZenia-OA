output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "secret_id" {
  description = "ID of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.rds_credentials.id
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.rds_credentials.name
}

output "secret_version_id" {
  description = "Unique identifier of the version of the secret"
  value       = aws_secretsmanager_secret_version.rds_credentials.version_id
}

