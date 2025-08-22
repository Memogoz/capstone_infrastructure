variable "prefix" {
  type    = string
  default = "ggonz-task"
}

variable "alb_sg_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
