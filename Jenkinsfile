pipeline {
    agent any
    
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
    }
    
}
