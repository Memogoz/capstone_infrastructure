variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "prefix" {
  type    = string
  default = "ggonz-task"
}

variable "az_a" {
  type    = string
  default = "us-east-1"
}

variable "az_b" {
  type    = string
  default = "us-east-2"
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}