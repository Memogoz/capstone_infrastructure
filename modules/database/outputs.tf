output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "rds_port" {
  value = aws_db_instance.postgres_db.port
}

output "rds_username" {
  value = aws_db_instance.postgres_db.username
}

output "rds_password" {
  value = aws_db_instance.postgres_db.password
}
