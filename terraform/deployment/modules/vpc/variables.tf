variable "vpc_cidr" {
  type        = string
  description = "Cidr block for vpc"
}

variable "public_subnet_count" {
  type        = number
  description = "Public subnet count"
  default     = 3
}

variable "private_subnet_count" {
  type        = number
  description = "Private subnet count"
  default     = 3
}