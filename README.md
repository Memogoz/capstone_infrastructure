# Terraform AWS Infrastructure with Jenkins CI/CD

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This project contains Terraform configurations to provision a scalable and secure infrastructure on AWS. The entire deployment process is automated using a Jenkins pipeline, which handles everything from infrastructure creation and configuration to its eventual destruction.

## Table of Contents

- [Project Description](#project-description)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [1. Configure AWS Credentials](#1-configure-aws-credentials)
  - [2. Set up Jenkins](#2-set-up-jenkins)
  - [3. Run the Pipeline](#3-run-the-pipeline)
- [Jenkins Pipeline Stages](#jenkins-pipeline-stages)
- [Terraform Modules](#terraform-modules)
- [Contributing](#contributing)
- [License](#license)

## Project Description

The goal of this project is to demonstrate a fully automated Infrastructure as Code (IaC) workflow. It uses Terraform to define and manage AWS resources in a modular and reusable way. A Jenkins pipeline orchestrates the deployment, providing a consistent and repeatable process for provisioning the environment.

The provisioned infrastructure includes:
- A custom VPC with public and private subnets across two availability zones.
- An Application Load Balancer (ALB) to distribute traffic to web servers.
- An Auto Scaling Group for web server EC2 instances.
- A Jenkins controller EC2 instance in a public subnet.
- An RDS database instance in a private subnet.
- Necessary IAM roles and security groups for secure communication between resources.
- An ECR repository for container images.

## Architecture

The infrastructure is composed of several interconnected modules:

1.  **Network**: Sets up the foundational networking layer, including the VPC, subnets, internet gateway, NAT gateways, and security groups.
2.  **Compute**: Provisions EC2 instances for the web application (managed by an Auto Scaling Group) and a dedicated Jenkins instance. It also creates an ECR repository.
3.  **ALB**: Deploys an Application Load Balancer to manage incoming traffic.
4.  **Database**: Creates a managed RDS instance for the application's data persistence.
5.  **IAM**: Manages all Identity and Access Management roles and policies required for the resources to interact securely with other AWS services.

## Prerequisites

Before you begin, ensure you have the following installed and configured on your Jenkins server/agent environment:

- **Jenkins**: An operational Jenkins server.
- **AWS CLI**: Configured with appropriate permissions to create the resources defined in the Terraform files.
- **Terraform**: The Terraform CLI.
- **Ansible**: For configuration management of the created nodes.
- **Python & Boto3**: Required for the `aws_ec2` Ansible inventory plugin.

## Getting Started

Follow these steps to deploy the infrastructure using the Jenkins pipeline.

### 1. Configure AWS Credentials

Ensure your Jenkins environment is configured with AWS credentials. The recommended way is to use the **AWS Credentials** plugin in Jenkins to store an IAM user's access key and secret key.

### 2. Set up Jenkins

1.  Create a new **Pipeline** project in Jenkins.
2.  In the "Pipeline" section, select **"Pipeline script from SCM"**.
3.  Choose **Git** as the SCM.
4.  Enter the repository URL for this project.
5.  Set the **Script Path** to `Jenkinsfile.groovy`.

### 3. Run the Pipeline

1.  Click on **"Build with Parameters"** for your newly created Jenkins job.
2.  The pipeline uses the following parameters:
    - `S3_BUCKET`: The name of the S3 bucket to store the Terraform state file. A default is provided.
    - `AWS_REGION`: The AWS region where the infrastructure will be deployed.
3.  Click **"Build"** to start the pipeline.

## Jenkins Pipeline Stages

The `Jenkinsfile` defines the CI/CD pipeline with the following stages:

1.  **S3 bucket creation for state storage**: Creates an S3 bucket for the Terraform remote state if it doesn't exist.
2.  **Backend initialization**: Initializes Terraform with the S3 backend configuration.
3.  **Configuration Formatting**: Checks if the Terraform code is correctly formatted.
4.  **Configuration Validation**: Validates the syntax of the Terraform files.
5.  **Plan**: Generates a Terraform execution plan and saves it as an artifact.
6.  **Wait for Approval**: Pauses the pipeline, waiting for manual approval before applying changes.
7.  **Provision of Resources**: Applies the Terraform plan to create or update the infrastructure.
8.  **Set up nodes with ansible**: Runs an Ansible playbook to configure the newly created EC2 instances (e.g., install Docker).
9.  **Wait for destroy signal**: Pauses the pipeline, waiting for a manual signal to tear down the infrastructure.
10. **Destroy**: Destroys all resources managed by Terraform.

## Terraform Modules

The Terraform configuration is organized into reusable modules located in the `./modules` directory:

- `network`: Manages all networking resources.
- `compute`: Manages EC2 instances, Auto Scaling Groups, and ECR.
- `alb`: Manages the Application Load Balancer and its target groups.
- `database`: Manages the RDS database.
- `iam`: Manages IAM roles and instance profiles.
