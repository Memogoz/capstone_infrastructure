variable "prefix" {
  type        = string
  description = "The prefix for all resources."
}

variable "db_name" {
  type        = string
  description = "The name of the database to create."
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "The username for the database."
}

variable "db_password" {
  type        = string
  description = "The password for the database."
  sensitive   = true
}

variable "instance_class" {
  type        = string
  description = "The instance class for the database."
  default     = "db.t3.micro"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs for the DB subnet group."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of VPC security group IDs to associate with the DB instance."
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the database is multi-AZ."
  default     = false
}
