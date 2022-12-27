# region
variable "aws_region" {
  description = "The region to use for this module."
  type        = string
}

variable "name" {
  description = "Name used across resources created"
  type        = string
}

variable "database_name" {
  description = "The Database name"
  type        = string
}

variable "database_username" {
  description = "The Database username"
  type        = string
}

variable "database_password" {
  description = "The Database password"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups"
}