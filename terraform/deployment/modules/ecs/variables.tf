# region
variable "aws_region" {
  description = "The region to use for this module."
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

################################################################################
# Project metadata
################################################################################
variable "cluster_id" {
  description = "The ECS cluster ID where the service should run"
  type        = string
}

variable "cluster_name" {
  description = "The ECS cluster name where the service should run"
  type        = string
}

################################################################################
# ECS Configuration
################################################################################
variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown. Only valid for services configured to use load balancers."
  default     = 180
}

################################################################################
# API Books Service Configuration
################################################################################
variable "logs_retention_in_days" {
  description = "Defines service logs retention period"
}

variable "task_definition" {
  description = "ECS task definition"
  type        = object({
    name              = string
    image             = string
    aws_logs_group    = string
    host_port         = number
    container_port    = number
    container_name    = string
    family            = string
    env_vars          = list(any)
    secret_vars       = list(any)
    health_check_path = string
  })
}

variable "service" {
  description = "ECS service"
  type        = object({
    name          = string
    desired_count = number
    max_count     = number
  })
}

variable "service_security_groups_ids" {
  description = "IDs of SG on a ecs task network"
}

variable "subnet_ids" {
  description = "The VPC subnets IDs where the application should run"
  type        = list(string)
}

variable "iam_role_ecs_task_execution_role" {
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf."
}

variable "iam_role_policy_ecs_task_execution_role" {
  description = "Policy of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf."
}

variable "alb_listener" {
  description = "Defines ALB listener where the service is registered"
}

variable "alb" {
  type = object({
    target_group       = string
    port               = optional(number, 80)
    protocol           = optional(string, "HTTP")
    target_type        = optional(string, "ip")
    arn                = string
    rule_priority      = number
    rule_type          = optional(string, "forward")
    target_group_paths = list(string)
  })
}

variable "autoscaling_settings" {
  type = object({
    autoscaling_name    = string
    max_capacity        = number
    min_capacity        = number
    target_cpu_value    = optional(number)
    target_memory_value = optional(number)
    scale_in_cooldown   = number
    scale_out_cooldown  = number
  })
  default     = null
  description = "Settings of based Auto Scaling."
}
