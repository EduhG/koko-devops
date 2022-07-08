pipeline {
    agent any

    triggers {
        githubPush()
    }
    
    stages {
        stage("Build Docker Image") {
            steps {
                script{
                    app = docker.build("koko-devops-app")
                }
            }
        }
        
        stage("Run Tests") {
            steps {
                sh 'docker run --rm koko-devops-app pytest -v'
            }
        }
        
        stage("Push to ECR") {
            when {
                branch "main"
            }
            steps {
                script{
                    docker.withRegistry('https://280052623973.dkr.ecr.eu-west-3.amazonaws.com/koko-devops-app', 'ecr:eu-west-3:koko-devops-aws-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        stage('Configure Kubernetes') {
            agent any

            when {
                branch "main"
            }
            
            steps {
                dir('devops/config') {
                    sh 'ansible-playbook --private-key ~/.ssh/aws-key -u ec2-user -i aws_ec2.yaml playbooks/ping.yaml'
                    sh 'ansible-playbook --private-key ~/.ssh/aws-key -u ec2-user -i aws_ec2.yaml playbooks/dependencies.yaml'
                    sh 'ansible-playbook --private-key ~/.ssh/aws-key -u ec2-user -i aws_ec2.yaml playbooks/master_node.yaml'
                    sh 'ansible-playbook --private-key ~/.ssh/aws-key -u ec2-user -i aws_ec2.yaml playbooks/worker_nodes.yaml'
                }
            }
        }

        stage('Deploy application') {
            agent any

            when {
                branch "main"
            }
            
            steps {
                dir('devops/kubernetes') {
                    sh 'kubectl apply -f app-deployment.yaml'
                    sh 'kubectl apply -f app-service.yaml'
                    sh 'kubectl rollout restart deployment koko-devops-app'
                }
            }
        }
    }
}
