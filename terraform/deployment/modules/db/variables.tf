# region
variable "aws_region" {
  description = "The region to use for this module."
  type        = string
}

variable "database_name" {
  description = "The Database name"
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

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "List of subnets cidr blocks"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups"
}