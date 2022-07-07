pipeline {
    agent none
    
    stages {
        stage('Clone Repo') {
            agent any
            steps {
                git branch: 'main', credentialsId: 'koko-devops-git-credentials-id', url: 'https://github.com/EduhG/koko-devops.git'
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
