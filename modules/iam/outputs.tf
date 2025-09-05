output "web_instance_profile_name" {
    value = aws_iam_instance_profile.ec2_web_instance_profile.name  
}

output "jenkins_instance_profile_name" {
    value = aws_iam_instance_profile.ec2_jenkins_instance_profile.name  
}