output "db_username_secret_arn" {
  description = "The ARN of the db username secret."
  value       = data.aws_secretsmanager_secret.database_username_secret.arn
}

output "db_password_secret_arn" {
  description = "The ARN of the db password secret."
  value       = data.aws_secretsmanager_secret.database_password_secret.arn
}

output "db_username_secret_value" {
  description = "The value of the db username secret."
  value       = data.aws_secretsmanager_secret_version.database_username_secret.secret_string
}

output "db_password_secret_value" {
  description = "The value of the db password secret."
  value       = data.aws_secretsmanager_secret_version.database_password_secret.secret_string
}