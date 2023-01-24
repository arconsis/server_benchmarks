locals {
  name = var.name
  tags = {
    Name = local.name
  }
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "14.5"
}

module "aurora_postgresql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 7.6.0"

  database_name     = var.database_name
  port              = "5432"
  name              = local.name
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true

  master_username        = var.database_username
  master_password        = var.database_password
  create_random_password = false

  vpc_id                = var.vpc_id
  subnets               = var.subnet_ids
  create_security_group = false

  vpc_security_group_ids = var.security_groups
  monitoring_interval    = 60

  apply_immediately   = true
  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  db_parameter_group_name         = aws_db_parameter_group.this.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 10
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    #    Re-enable when we have checked how to connect Quarkus
    #    and Spring Boot to different writer/reader endpoints
    #    two = {}
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${local.name}-db-parameter-group"
  family      = "aurora-postgresql14"
  description = "${local.name}-db-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${local.name}-cluster-parameter-group"
  family      = "aurora-postgresql14"
  description = "${local.name}-cluster-parameter-group"
  tags        = local.tags
}