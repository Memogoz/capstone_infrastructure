resource "aws_iam_role" "ec2_web_role" {
  name = "ec2-web-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "EC2ECRPullPolicy"
  description = "Allow EC2 instances to authenticate to ECR and pull images"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = var.ecr_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  role       = aws_iam_role.ec2_web_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

resource "aws_iam_instance_profile" "ec2_web_instance_profile" {
  name = "ec2-web-instance-profile"
  role = aws_iam_role.ec2_web_role.name
}

resource "aws_iam_role" "ec2_jenkins_admin_role" {
  name = "ec2-jenkins-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_jenkins_admin_policy" {
    name        = "EC2JenkinsAdminPolicy"
    description = "Allow jenkins worker instance to admin services"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Action = [
            "*"
            ],
            Resource = "*"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_ec2_jenkins_admin_policy" {
    role       = aws_iam_role.ec2_jenkins_admin_role.name
    policy_arn = aws_iam_policy.ec2_jenkins_admin_policy.arn
}

resource "aws_iam_instance_profile" "ec2_jenkins_instance_profile" {
    name = "ec2-jenkins-instance-profile"
    role = aws_iam_role.ec2_jenkins_admin_role.name
}