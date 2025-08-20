pipeline {
    agent any

    parameters {
        string(name: 'S3_BUCKET', defaultValue: 'default-terraform-state-bucket-871964', description: 'Enter the S3 bucket name')
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'Enter the AWS region')
    }

    stages {
        stage('S3 bucket creation for state storage') {
            steps {
                echo "Creating S3 bucket or checking if it already exists..."
                sh """
                    aws s3 mb "s3://${params.S3_BUCKET}" --region "${params.AWS_REGION}"
                """
            }
        }
        stage("Backend inicialization") {
            steps {
                echo "Initializing backend..."
                sh """
                    terraform init -reconfigure \\
                    -backend-config="bucket=${params.S3_BUCKET}" \\
                    -backend-config="region=${params.AWS_REGION}"
                """
            }
        }
        stage('Configuration Formatting') {
            steps {
                echo 'Checking formatting...'
                sh 'terraform fmt -recursive ./'
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
                sh """
                    terraform plan -var "aws_region=${params.AWS_REGION}" -out=plan.tfplan
                """
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
                sh 'terraform apply -auto-approve -input=false plan.tfplan'
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
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}