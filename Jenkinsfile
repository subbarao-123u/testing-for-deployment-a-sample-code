pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("my-flask-app:latest")
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    def dockerImage = docker.build("my-flask-app:latest")
                    dockerImage.inside() {
                        sh '''
                            sleep 5
                            python -c "
import requests
try:
    r = requests.get('http://localhost:5000', timeout=5)
    if 'Hello from Docker container!' in r.text:
        print('✓ TEST PASSED')
    else:
        print('✗ TEST FAILED')
        exit(1)
except:
    print('✗ CONNECTION FAILED')
    exit(1)
                            "
                        '''
                    }
                }
            }
        }
    }
}

