################################################################################
# General AWS Configuration
################################################################################
variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "The AWS profile name"
  default     = "arconsis"
}

variable "cidr_block" {
  description = "Network IP range"
  default     = "10.0.0.0/16"
}

variable "image_tag" {
  description = "Defines image tag used for all containers"
  default     = "latest"
}

variable "quarkus_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-quarkus"
}

variable "quarkus_sync_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-quarkus-sync"
}

variable "springboot_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-springboot"
}

variable "nestjs_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-nestjs"
}

variable "actix_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-actix"
}

variable "vapor_bookstore_image" {
  description = "Defines container image"
  default     = "143441946271.dkr.ecr.eu-west-1.amazonaws.com/bookstore-vapor"
}