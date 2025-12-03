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
                    TEST_PORT=$((9000 + ${BUILD_ID} % 100))
                    echo "Testing on port $TEST_PORT"
                    docker run --rm -d -p $TEST_PORT:5000 --name test-app-${BUILD_ID} my-flask-app:${BUILD_ID}
                    sleep 8
                    curl_result=$(curl -s http://localhost:$TEST_PORT)
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
                    echo "🚀 DEPLOYING BUILD ${BUILD_ID}..."
                    docker stop test-app-${BUILD_ID} || true
                    docker rm test-app-${BUILD_ID} || true
                    docker run -d -p 80:5000 --restart unless-stopped --name prod-app my-flask-app:${BUILD_ID}
                    sleep 5
                    health_check=$(curl -s http://localhost:80 --max-time 10 || echo "DOWN")
                    if echo "$health_check" | grep -q "Hello"; then
                        echo "✅ LIVE! Build ${BUILD_ID}"
                        docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}" | grep prod-app
                    else
                        echo "❌ FAILED: $health_check"
                        exit 1
                    fi
                '''
            }
        }
    }  // ← THIS CLOSING BRACE WAS MISSING!
}
