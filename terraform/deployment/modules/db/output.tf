output "aurora_postgresql_v2_cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora_postgresql_v2.cluster_endpoint
}

output "aurora_postgresql_v2_cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.aurora_postgresql_v2.cluster_reader_endpoint
}

output "database_username" {
  description = "The database master username"
  value       = module.aurora_postgresql_v2.cluster_master_username
}

output "database_password" {
  description = "The database master password"
  value       = module.aurora_postgresql_v2.cluster_master_password
}