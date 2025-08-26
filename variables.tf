variable "aws_region" {
  type = string
}

variable "db_username" {
  type        = string
  description = "Username for the RDS database."
  default     = "admin_ggonz"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database."
  sensitive   = true
  default     = "password_ggonz"
}
