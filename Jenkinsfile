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
                            sleep 8
                            python -c "
import socket
import time

def test_flask():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(5)
    try:
        s.connect(('localhost', 5000))
        s.send(b'GET / HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n')
        response = s.recv(1024).decode()
        if 'Hello from Docker container!' in response:
            print('✓ TEST PASSED - Flask responding correctly')
            return 0
        else:
            print('✗ TEST FAILED - Wrong response')
            return 1
    except Exception as e:
        print('✗ CONNECTION FAILED:', str(e))
        return 1
    finally:
        s.close()

exit(test_flask())
                            "
                        '''
                    }
                }
            }
        }
    }
}

