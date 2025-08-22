variable "prefix" {
  type    = string
  default = "ggonz-task"
}

variable "web_ami_id" {
  type = string
}

variable "web_instance_type" {
  type    = string
  default = "t3.small"
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arns" {
  type = list(string)
}

variable "web_desired_count" {
  type    = number
  default = 3
}

variable "user_data" {
  type = string
}

variable "web_sg_ids" {
  type = list(string)
}