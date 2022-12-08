output "db_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora_postgresql_v2.cluster_endpoint
}

output "db_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.aurora_postgresql_v2.cluster_reader_endpoint
}

output "db_name" {
  description = "The database name"
  value       = module.aurora_postgresql_v2.cluster_database_name
}

output "db_port" {
  description = "The database port"
  value       = module.aurora_postgresql_v2.cluster_port
}

output "db_username" {
  description = "The database master username"
  sensitive   = true
  value       = module.aurora_postgresql_v2.cluster_master_username
}

output "db_password" {
  description = "The database master password"
  sensitive   = true
  value       = module.aurora_postgresql_v2.cluster_master_password
}