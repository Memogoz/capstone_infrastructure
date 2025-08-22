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
    key = "infrastructure/terraform.tfstate"
    #region       = "" parsed from the terraform init command
    use_lockfile = true
    encrypt      = true
  }
}