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

variable "repositories" {
  description = "Defines the repositories to create"
  type        = set(string)
  default = [
    "bookstore-quarkus-reactive",
    "bookstore-quarkus-sync",
    "bookstore-springboot",
    "bookstore-nestjs",
    "bookstore-actix",
    "bookstore-vapor",
    "bookstore-rocketrs"
  ]
}
