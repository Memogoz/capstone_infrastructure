# modules/network/main.tf

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags       = { Name = "${var.prefix}-vpc" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = var.az_a
  tags              = { Name = "${var.prefix}-private-${var.az_a}" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = var.az_b
  tags              = { Name = "${var.prefix}-private-${var.az_b}" }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.prefix}-public-${var.az_a}" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.prefix}-public-${var.az_b}" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.prefix}-igw" }
}

resource "aws_eip" "public_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags       = { Name = "${var.prefix}-nat-eip-a" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.public_ip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = { Name = "${var.prefix}-nat-gw_a" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.prefix}-public-rt" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.prefix}-private-rt" }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "alb_sg" { # Allow HTTP and allowed IPs to the load balancer
  name        = "${var.prefix}-alb-sg"
  description = "Allow HTTP from allowed CIDRs"
  vpc_id      = aws_vpc.this.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.prefix}-alb-sg" }
}

resource "aws_security_group" "web_sg" { # Allow HTTP from ALB and SSH from admin nodes to web servers
  name        = "${var.prefix}-web-sg"
  description = "Allow HTTP from ALB and SSH from admin nodes"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow HTTP from ALB"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.allowed_cidrs
    description     = "Allow SSH from admin nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.prefix}-web-sg" }
}

resource "aws_security_group" "db_sg" { # Allow PostgreSQL traffic to web servers
  name        = "${var.prefix}-db-sg"
  description = "Allow PostgreSQL traffic from web servers"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    description     = "Allow PostgreSQL from Web SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-db-sg" }
}

/*
resource "aws_security_group" "admin_nodes_sg" { # Allow SSH to admin nodes [MAYBE THIS SG SHOULD BE PREVIUSLY CREATED]
  name        = "${var.prefix}-jenkins-nodes-sg"
  description = "Allow SSH from admin nodes"
  vpc_id      = aws_vpc.this.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.prefix}-admin-sg" }
}
*/