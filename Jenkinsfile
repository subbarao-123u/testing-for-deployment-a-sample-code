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
                    dockerImage.inside('--entrypoint=""') {
                        sh '''
                            sleep 2
                            nohup python app.py > /dev/null 2>&1 &
                            sleep 6
                            python -c "
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(3)
try:
    s.connect(('localhost', 5000))
    s.send(b'GET / HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n')
    resp = s.recv(1024).decode()
    if 'Hello from Docker container!' in resp:
        print('✓ TEST PASSED')
        exit(0)
    else:
        print('✗ WRONG RESPONSE')
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

