variable "aws_region" {
  description = "The AWS region things are created in"
}

variable "cidr_block" {
  description = "Network IP range"
  default     = "10.0.0.0/16"
}

variable "image_tag" {
  description = "Defines image tag used for all containers"
  default     = "latest"
}

variable "ecs_apps_configs" {
  description = "Configuration for running apps on AWS ECS"
  type = list(object({
    target_group      = string
    target_group_paths = list(string)
    name              = string
    image             = string
    image_tag = optional(string, "latest")
    host_port         = number
    container_port    = number
    container_name    = string
    health_check_path = string
    env_vars = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default = []
}