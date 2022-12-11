provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = var.aws_profile
  region                   = var.aws_region
  #  default_tags {
  #    tags = var.default_tags
  #  }
}

resource "aws_ecs_cluster" "main" {
  name = "server-benchmarks"
  tags = {
    Name = "server-benchmarks-ecs-cluster"
  }
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.cidr_block
}

module "alb_sg" {
  source            = "./modules/security"
  sg_name           = "load-balancer-security-group"
  description       = "controls access to the ALB"
  vpc_id            = module.vpc.vpc_id
  egress_cidr_rules = {
    1 = {
      description      = "allow all outbound"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress_source_sg_rules = {}
  ingress_cidr_rules     = {
    1 = {
      description      = "controls access to the ALB"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ingress_source_sg_rules = {}
}

module "public_alb" {
  source             = "./modules/alb"
  load_balancer_type = "application"
  alb_name           = "main-ecs-lb"
  internal           = false
  vpc_id             = module.vpc.vpc_id
  security_groups    = [module.alb_sg.security_group_id]
  subnet_ids         = module.vpc.public_subnet_ids
  http_tcp_listeners = [
    {
      port           = 80
      protocol       = "HTTP"
      action_type    = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Resource not found"
        status_code  = "404"
      }
    }
  ]
}

################################################################################
# ECS Tasks Execution IAM
################################################################################
# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "ecs_tasks_sg" {
  source            = "./modules/security"
  sg_name           = "ecs-tasks-security-group"
  description       = "controls access to the ECS tasks"
  vpc_id            = module.vpc.vpc_id
  egress_cidr_rules = {
    1 = {
      description      = "allow all outbound"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress_source_sg_rules  = {}
  ingress_source_sg_rules = {
    1 = {
      description              = "allow inbound access from the ALB only"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      source_security_group_id = module.alb_sg.security_group_id
    }
  }
  ingress_cidr_rules = {}
}

module "ecs_quarkus_app" {
  source       = "./modules/ecs"
  alb_listener = module.public_alb.alb_listener
  alb          = {
    target_group       = "quarkus-tg"
    target_group_paths = ["/quarkus/*"]
    arn                = module.public_alb.alb_listener_http_tcp_arn
    rule_priority      = 1
  }
  aws_region                              = var.aws_region
  cluster_id                              = aws_ecs_cluster.main.id
  cluster_name                            = aws_ecs_cluster.main.name
  fargate_cpu                             = "256"
  fargate_memory                          = "1024"
  iam_role_ecs_task_execution_role        = aws_iam_role.ecs_task_execution_role
  iam_role_policy_ecs_task_execution_role = aws_iam_role_policy_attachment.ecs_task_execution_role
  logs_retention_in_days                  = 30
  service_security_groups_ids             = [module.ecs_tasks_sg.security_group_id]
  subnet_ids                              = module.vpc.private_subnet_ids
  vpc_id                                  = module.vpc.vpc_id
  service                                 = {
    name          = "bookstore-quarkus"
    desired_count = 1
    max_count     = 1
  }
  task_definition = {
    name              = "bookstore-quarkus"
    image             = var.quarkus_bookstore_image
    aws_logs_group    = "ecs/bookstore-quarkus"
    host_port         = 3000
    container_port    = 3000
    container_name    = "bookstore-quarkus"
    health_check_path = "/q/health"
    family            = "bookstore-quarkus-task"
    env_vars          = [
      #      Check how to configure writer and reader endpoints
      {
        "name" : "DB_HOST",
        "value" : tostring(module.books-database.db_endpoint),
      },
      {
        "name" : "DB_NAME",
        "value" : tostring(module.books-database.db_name),
      },
      {
        "name" : "DB_PORT",
        "value" : tostring(module.books-database.db_port),
      }
    ]
    secret_vars = [
      {
        "name" : "DB_USER",
        "valueFrom" : module.database_secrets.db_username_secret_arn,
      },
      {
        "name" : "DB_PASSWORD",
        "valueFrom" : module.database_secrets.db_password_secret_arn,
      }
    ]
  }
}

module "ecs_springboot_app" {
  source       = "./modules/ecs"
  alb_listener = module.public_alb.alb_listener
  alb          = {
    target_group       = "springboot-tg"
    target_group_paths = ["/springboot/*"]
    arn                = module.public_alb.alb_listener_http_tcp_arn
    rule_priority      = 2
  }
  aws_region                              = var.aws_region
  cluster_id                              = aws_ecs_cluster.main.id
  cluster_name                            = aws_ecs_cluster.main.name
  fargate_cpu                             = "256"
  fargate_memory                          = "1024"
  iam_role_ecs_task_execution_role        = aws_iam_role.ecs_task_execution_role
  iam_role_policy_ecs_task_execution_role = aws_iam_role_policy_attachment.ecs_task_execution_role
  logs_retention_in_days                  = 30
  service_security_groups_ids             = [module.ecs_tasks_sg.security_group_id]
  subnet_ids                              = module.vpc.private_subnet_ids
  vpc_id                                  = module.vpc.vpc_id
  service                                 = {
    name          = "bookstore-springboot"
    desired_count = 1
    max_count     = 1
  }
  task_definition = {
    name              = "bookstore-springboot"
    image             = var.springboot_bookstore_image
    aws_logs_group    = "ecs/bookstore-springboot"
    host_port         = 3000
    container_port    = 3000
    container_name    = "bookstore-springboot"
    health_check_path = "/actuator/health"
    family            = "bookstore-springboot-task"
    env_vars          = [
      #      Check how to configure writer and reader endpoints
      {
        "name" : "DB_HOST",
        "value" : tostring(module.books-database.db_endpoint),
      },
      {
        "name" : "DB_NAME",
        "value" : tostring(module.books-database.db_name),
      },
      {
        "name" : "DB_PORT",
        "value" : tostring(module.books-database.db_port),
      },
      {
        "name": "SPRING_PROFILES_ACTIVE",
        "value": "prod"
      }
    ]
    secret_vars = [
      {
        "name" : "DB_USER",
        "valueFrom" : module.database_secrets.db_username_secret_arn,
      },
      {
        "name" : "DB_PASSWORD",
        "valueFrom" : module.database_secrets.db_password_secret_arn,
      }
    ]
  }
}

################################################################################
# Database
################################################################################

module "database_secrets" {
  source                = "./modules/secrets"
  database_password_key = "booksdb_password"
  database_username_key = "booksdb_username"
  role_id               = aws_iam_role.ecs_task_execution_role.id
}

module "private_database_sg" {
  source            = "./modules/security"
  sg_name           = "private_database_sg"
  description       = "Controls access to the private database (not internet facing)"
  vpc_id            = module.vpc.vpc_id
  egress_cidr_rules = {
    1 = {
      description      = "allow all outbound"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress_source_sg_rules  = {}
  ingress_source_sg_rules = {}
  ingress_cidr_rules      = {
    1 = {
      description      = "allow inbound access only from resources in VPC"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = [module.vpc.vpc_cidr_block]
      ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
    }
  }
}

# In a real-life scenario we should a specific db for each microservice
module "books-database" {
  source            = "./modules/db"
  aws_region        = var.aws_region
  database_name     = "booksdb"
  subnet_ids        = module.vpc.private_subnet_ids
  security_groups   = [module.private_database_sg.security_group_id]
  vpc_id            = module.vpc.vpc_id
  database_password = module.database_secrets.db_password_secret_value
  database_username = module.database_secrets.db_username_secret_value
}

################################################################################
# VPC Flow Logs IAM
################################################################################
resource "aws_iam_role" "vpc_flow_cloudwatch_logs_role" {
  name               = "vpc-flow-cloudwatch-logs-role"
  assume_role_policy = file("./common/templates/policies/vpc_flow_cloudwatch_logs_role.json.tpl")
}

resource "aws_iam_role_policy" "vpc_flow_cloudwatch_logs_policy" {
  name   = "vpc-flow-cloudwatch-logs-policy"
  role   = aws_iam_role.vpc_flow_cloudwatch_logs_role.id
  policy = file("./common/templates/policies/vpc_flow_cloudwatch_logs_policy.json.tpl")
}

# VPC Flows
################################################################################
# Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a specific network interface,
# subnet, or VPC. Logs are sent to a CloudWatch Log Group or a S3 Bucket.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_cloudwatch_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "bookstore-vpc-flow-logs"
  retention_in_days = 30
}