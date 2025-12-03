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
                    def dockerImage = docker.build("my-flask-app:${env.BUILD_ID}")
                }
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    docker run --rm -d -p 9000:5000 --name test-app my-flask-app:${BUILD_ID}
                    sleep 8
                    curl_result=$(curl -s http://localhost:9000)
                    if echo "$curl_result" | grep -q "Hello from Docker container!"; then
                        echo "✓ TEST PASSED: $curl_result"
                    else
                        echo "✗ TEST FAILED: $curl_result"
                        exit 1
                    fi
                    docker stop test-app
                    docker rm test-app
                '''
            }
        }
    }
}

