resource "aws_db_subnet_group" "this" {
  name       = "${var.prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres_db" {
  identifier             = "${var.prefix}-postgres-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "17.5" # Using a stable version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = false
  skip_final_snapshot    = true # Set to false in production

  tags = {
    Name = "${var.prefix}-postgres-db"
  }
}
