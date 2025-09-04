output "ecr_repository_url" {
  value = aws_ecr_repository.image_repository.repository_url
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.image_repository.arn
}