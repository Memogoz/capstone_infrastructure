
module "network" {
  source        = "./modules/network"
  prefix        = "ggonz-capstone"
  vpc_cidr      = "10.0.0.0/16"
  az_a          = "${var.aws_region}a"
  az_b          = "${var.aws_region}b"
  allowed_cidrs = ["201.163.120.0/24"]
}

module "alb" {
  source     = "./modules/alb"
  prefix     = "ggonz-capstone"
  subnet_ids = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
  alb_sg_ids = [module.network.alb_sg_id]
}

module "compute" {
  source                = "./modules/compute"
  prefix                = "ggonz-capstone"
  web_ami_id            = data.aws_ami.ubuntu.id
  web_instance_type     = "t3.micro"
  subnet_ids            = module.network.private_subnet_ids
  alb_target_group_arns = [module.alb.alb_target_group_arn]
  web_desired_count     = 3
  user_data             = file("web-user-data.sh")
  web_sg_ids            = [module.network.web_sg_id]
}

module "database" {
  source                 = "./modules/database"
  prefix                 = "ggonz-capstone"
  subnet_ids             = module.network.private_subnet_ids
  vpc_security_group_ids = [module.network.db_sg_id]
  db_username            = var.db_username
  db_password            = var.db_password
}
