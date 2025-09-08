output "ecr_repository_url" {
  value = aws_ecr_repository.image_repository.repository_url
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.image_repository.arn
}

output "jenkins_worker_ip" {
  value = aws_instance.jenkins_worker.public_ip
}