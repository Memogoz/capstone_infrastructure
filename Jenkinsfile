pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'terraform-state-storage-1234'
    }

    stages {
        stage('S3 bucket creation for state storage') {
            steps {
                echo "Creating S3 bucket or checking if it already exists..."
                sh 'aws s3 mb "s3://$S3_BUCKET" --region "$AWS_REGION"'
            }
        }
        stage('Configuration Formatting') {
            steps {
                echo 'Checking formatting...'
                sh 'terraform fmt -check -recursive ./'
            }
        }
        stage('Configuration Validation') {
            steps {
                echo 'Validating configuration...'
                sh 'terraform validate'
            }
        }
        stage('Plan') {
            steps {
                echo 'Planning...'
                sh 'terraform plan -out plan.tfplan'
                sh 'terraform show plan.tfplan'
            }
        }
        stage('Wait for Approval') {
            steps {
                echo 'Waiting for approval...'
                input message: "Approve to apply plan changes?"
            }
        }
        stage('Provision of Resources') {
            steps {
                echo 'Provisioning Resources...'
                sh 'terraform apply'
            }
        }
        stage('Wait for destroy signal') {
            steps {
                echo "Waiting for destroy signal"
                input message: "Destroy?"
            }
        }
        stage('Destroy') {
            steps {
                echo 'Destroying resources...'
                sh 'terraform destroy'
            }
        }
    }
}