pipeline {
    agent any

    environment {
        REGISTRY_URL = "localhost:5000"  // YOUR local registry
        IMAGE_NAME = "${REGISTRY_URL}/my-flask-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${env.BUILD_ID} ."
                sh "docker tag ${IMAGE_NAME}:${env.BUILD_ID} ${IMAGE_NAME}:latest"
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    docker run --rm -d -p 9000:5000 --name test-app-${BUILD_ID} ${IMAGE_NAME}:${BUILD_ID}
                    sleep 8
                    curl_result=$(curl -s http://localhost:9000)
                    if echo "$curl_result" | grep -q "Hello from Docker container!"; then
                        echo "✓ TEST PASSED: $curl_result"
                    else
                        echo "✗ TEST FAILED: $curl_result"
                        exit 1
                    fi
                '''
            }
        }

        stage('Deploy Production') {
            steps {
                sh '''
                    # Stop existing production app
                    docker stop prod-app || true
                    docker rm prod-app || true
                    
                    # Deploy new version
                    docker run -d -p 80:5000 \
                        --restart unless-stopped \
                        --name prod-app \
                        my-flask-app:${BUILD_ID}
                    
                    # Health check
                    sleep 5
                    curl_result=$(curl -s http://localhost || echo "DOWN")
                    if echo "$curl_result" | grep -q "Hello"; then
                        echo "🚀 DEPLOYMENT SUCCESSFUL!"
                        echo "Live at: http://localhost (port 80)"
                        echo "Build: ${BUILD_ID}"
                    else
                        echo "🚨 DEPLOYMENT FAILED - Health check"
                        exit 1
                    fi
                '''
            }
        }
    }
}
