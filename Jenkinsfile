pipeline {
    agent any

    environment {
        IMAGE_NAME = "nisshaa/deployment"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'git-token', url: 'https://github.com/Nisha-Velmurugan/deployment.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                set -e
                docker run --rm -e PYTHONPATH=/app -w /app $IMAGE_NAME:latest pytest tests/
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    set -e
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                // Simulate a successful deployment
                sh '''
                echo "Simulating deployment..."
                echo "Application deployed successfully!"
                '''
            }
        }
    }

    post {
        failure {
            echo "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}. Check Jenkins logs for details."
        }
        success {
            echo "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}. Application deployed successfully."
        }
    }
}
