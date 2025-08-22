# modules/compute/main.tf
resource "aws_launch_template" "web_lt" {
  name_prefix            = "${var.prefix}-template-instance"
  image_id               = var.web_ami_id
  instance_type          = var.web_instance_type
  user_data              = base64encode(var.user_data)
  vpc_security_group_ids = var.web_sg_ids
}

resource "aws_autoscaling_group" "web_asg" {
  name             = "${var.prefix}-asg"
  min_size         = var.web_desired_count - (var.web_desired_count / 2 + (var.web_desired_count % 2) / 2)
  max_size         = var.web_desired_count + (var.web_desired_count / 2 + (var.web_desired_count % 2) / 2)
  desired_capacity = var.web_desired_count 
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.alb_target_group_arns
  health_check_type   = "ELB"
  force_delete        = true
}

resource "aws_ecr_repository" "image_repository" {
  name                 = "capstone-petclinic-images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}