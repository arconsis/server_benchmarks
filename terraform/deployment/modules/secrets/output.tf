output "db_username_secret_arn" {
  description = "The ARN of the db username secret we created."
  value       = data.aws_secretsmanager_secret.database_username_secret.arn
}

output "db_password_secret_arn" {
  description = "The ARN of the db password secret we created."
  value       = data.aws_secretsmanager_secret.database_password_secret.arn
}