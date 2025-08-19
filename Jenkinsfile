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
                aws s3 mb "s3://${environment.S3_BUCKET}" --region "${environment.AWS_REGION}"
            }
        }
        stage('Configuration Formatting') {
            steps {
                echo 'Checking formatting...'
                terraform fmt -check -recursive ./
            }
        }
        stage('Configuration Validation') {
            steps {
                echo 'Validating configuration...'
                terraform validate
            }
        }
        stage('Plan') {
            steps {
                echo 'Planning...'
                terraform plan -out plan.tfplan
                terraform show plan.tfplan
            }
        }
        stage('Wait for Approval'){
            steps {
                echo 'Waiting for approval...'
                input message: "Approve to apply plan changes?"
            }
        }
        stage('Provision of Resources') {
            steps {
                echo 'Provisioning Resources...'
                terraform apply
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
                terraform destroy
            }
        }
    }
}