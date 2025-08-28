output "ecr_repo_url" {
  value = module.compute.ecr_repository_url
}

output "website_url" {
  value = module.alb.alb_dns_name
}

output "postgres_host" {
  value = module.database.rds_endpoint
}

output "postgres_port" {
  value = module.database.rds_port
}

output "postgres_username" {
  value = module.database.rds_username
}

output "postgres_password" {
  value = module.database.rds_password
}

output "postgres_db_name" {
  value = module.database.rds_db_name
}
