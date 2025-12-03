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
            echo "🚀 DEPLOYING LOCAL IMAGE my-flask-app:${BUILD_ID}..."
            
            # Verify image exists
            docker images my-flask-app:${BUILD_ID} || (echo "❌ Image missing!" && exit 1)
            
            # Stop old prod app
            docker stop prod-app || true
            docker rm prod-app || true
            
            # Deploy EXACT local image
            docker run -d \
                -p 80:5000 \
                --restart unless-stopped \
                --name prod-app \
                my-flask-app:${BUILD_ID}
            
            sleep 5
            health_check=$(curl -s http://localhost:80 --max-time 10 || echo "DOWN")
            
            if echo "$health_check" | grep -q "Hello"; then
                echo "✅ LIVE! Build ${BUILD_ID}"
                docker ps --format "table {{.Names}}\\t{{.Ports}}\\t{{.Status}}" | grep prod-app
            else
                echo "❌ Health check failed: $health_check"
                exit 1
            fi
        '''
    }
}







      
