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
            steps {
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


pipeline {
    agent none
    
    stages {
        stage('Clone Repo') {
            agent any
            steps {
                // git branch: 'main', credentialsId: 'personal-github', url: 'https://github.com/EduhG/koko-devops.git'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'personal-github', url: 'https://github.com/EduhG/koko-devops.git']]])
            }
        }
        
        stage('Build Image, Test and Push to ECR') {
            agent any
            
            stages {
                stage("Build Docker Image") {
                    steps {
                        script{
                            app = docker.build("koko-devops-app-test")
                        }
                    }
                }
               
                stage("Run Tests") {
                    steps {
                        sh 'docker run --rm koko-devops-app-test pytest -v'
                    }
                }
                
                stage("Push to ECR") {
                    steps {
                        sh 'docker run --rm koko-devops-app-test pytest -v'
                       
                        script{
                            docker.withRegistry('https://280052623973.dkr.ecr.eu-west-3.amazonaws.com/koko-devops-app-test', 'ecr:eu-west-3:koko-devops-aws-credentials') {
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