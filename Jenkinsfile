pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-flask-app"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    dockerImage.inside("-p 5000:5000") {
                        sh 'curl -s http://localhost:5000 | grep "Hello from Docker container!"'
                    }
                }
            }
        }
    }
}

