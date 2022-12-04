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

variable "quarkus_bookstore_image" {
  description = "Defines container image"
}

variable "springboot_bookstore_image" {
  description = "Defines container image"
}