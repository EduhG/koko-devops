pipeline {
    agent none

    environment {
        IMAGE_NAME = credentials("koko-devops-image-name")
        GIT_REPO_LINK = credentials("koko-devops-git-repo-link")
        GIT_CREDENTIALS_ID = credentials("koko-devops-git-credentials-id")
        ECR_BASE_URL = credentials("koko-devops-ecr-base-url")
        AWS_REGION = credentials("koko-devops-aws-region")
    }
    
    stages {
        stage('Clone Repo') {
            agent any
            script {
                checkout scm
            }
        }
        
        stage('Build Image, Test and Push to ECR') {
            agent any
            
            stages {
                stage("Build Docker Image") {
                    steps {
                        script{
                            app = docker.build("${IMAGE_NAME}")
                        }
                    }
                }
               
                stage("Run Tests") {
                    steps {
                        sh 'docker run --rm ${IMAGE_NAME} pytest -v'
                    }
                }
                
                stage("Push to ECR") {
                    steps {
                        script{
                            docker.withRegistry('${ECR_BASE_URL}/${IMAGE_NAME}', 'ecr:${AWS_REGION}:koko-devops-aws-credentials') {
                                app.push("${env.BUILD_NUMBER}")
                                app.push("latest")
                            }
                        }
                    }
                }
            }
        }
    }
}
