terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.3.0"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    #bucket       = "" parsed from the terraform init command
    key          = "infrastructure/terraform.tfstate"
    #region       = "" parsed from the terraform init command
    use_lockfile = true
    encrypt      = true
  }
}

resource "aws_instance" "sample_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  tags = {
    Name = "ggonz-test-instance"
    project = "2025_internship_gdl"
    owner = "ggonzalez"
  }
}