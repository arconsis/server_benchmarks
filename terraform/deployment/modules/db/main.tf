locals {
  name = var.database_name
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

  database_name     = local.name
  port              = "5432"
  name              = local.name
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true

  vpc_id                = var.vpc_id
  subnets               = var.subnet_ids
  create_security_group = false

  allowed_security_groups = var.security_groups
  allowed_cidr_blocks     = var.subnet_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.this.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 10
  }

  instance_class = "db.serverless"
  instances      = {
    one = {}
    two = {}
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