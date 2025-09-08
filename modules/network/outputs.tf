output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

/*
output "admin_nodes_sg_id" {
  value = aws_security_group.admin_nodes_sg.id
}
*/