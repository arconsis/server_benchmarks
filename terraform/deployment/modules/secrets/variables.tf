variable "database_username_key" {
  description = "Database username secret key"
  type        = string
}

variable "database_password_key" {
  description = "Database password secret key"
  type        = string
}

variable "role_id" {
  description = "The role id for the secrets policy"
  type        = string
}