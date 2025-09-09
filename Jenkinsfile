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
        stage('Set up nodes with ansible') {
            steps {
                echo 'Setting up nodes with Ansible...'
                script {
                    def region = params.AWS_REGION
                    sh """
                        echo "Fetching Bastion IP..."
                        BASTION_IP=\$(aws ec2 describe-instances \
                            --region ${region} \
                            --filters "Name=tag:Role,Values=bastion" "Name=instance-state-name,Values=running" \
                            --query "Reservations[].Instances[].PublicIpAddress" \
                            --output text)

                        echo "Running Ansible playbook using bastion at \$BASTION_IP"

                        export ANSIBLE_CONFIG=./Ansible/ansible.cfg

                        ~/venv/bin/ansible-playbook \
                            -i ./Ansible/inventory.aws_ec2.yaml \
                            ./Ansible/docker-setup.yaml \
                            --ssh-common-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ~/.aws-keys/jenkins-worker-key -W %h:%p -q ubuntu@'\$BASTION_IP'"' \
                            --private-key='~/.aws-keys/web-instances-key'
                    """
                }
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