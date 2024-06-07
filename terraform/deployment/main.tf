provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  #  profile                  = var.aws_profile
  region = var.aws_region
  #  default_tags {
  #    tags = var.default_tags
  #  }
}

module "ecs_apps" {
  source = "./modules/base"

  aws_region = var.aws_region

  ecs_apps_configs = [
    {
      target_group      = "quarkus-tg"
      target_group_paths = ["/quarkus/*"]
      name              = "bookstore-quarkus-reactive"
      image             = "bookstore-quarkus-reactive"
      host_port         = 3000
      container_port    = 3000
      container_name    = "bookstore-quarkus-reactive"
      health_check_path = "/quarkus/q/health"
    },
    {
      target_group      = "quarkus-sync-tg"
      target_group_paths = ["/quarkus-sync/*"]
      name              = "bookstore-quarkus-sync"
      image             = "bookstore-quarkus-sync"
      host_port         = 3000
      container_port    = 3000
      container_name    = "bookstore-quarkus-sync"
      health_check_path = "/quarkus-sync/q/health"
    },
    {
      target_group   = "springboot-tg"
      target_group_paths = ["/springboot/*"]
      name           = "bookstore-springboot"
      image          = "bookstore-springboot"
      host_port      = 3000
      container_port = 3000
      container_name = "bookstore-springboot"
      health_check_path = "/springboot/actuator/health"
      #       Only if extra env vars are needed
      env_vars = [
        {
          "name" : "SPRING_PROFILES_ACTIVE",
          "value" : "prod"
        }
      ]
    },
    {
      target_group      = "nestjs-tg"
      target_group_paths = ["/nestjs/*"]
      name              = "bookstore-nestjs"
      image             = "bookstore-nestjs"
      host_port         = 3000
      container_port    = 3000
      container_name    = "bookstore-nestjs"
      health_check_path = "/nestjs/health"
      env_vars = [
        {
          "name" : "APP_PORT",
          "value" : "3000"
        },
        {
          "name" : "USE_FASTIFY",
          "value" : "true"
        }
      ]
    },
    {
      target_group      = "actix-tg"
      target_group_paths = ["/actix/*"]
      name              = "bookstore-actix"
      image             = "bookstore-actix"
      host_port         = 3000
      container_port    = 3000
      container_name    = "bookstore-actix"
      health_check_path = "/actix/a/health"
    }
  ]
}