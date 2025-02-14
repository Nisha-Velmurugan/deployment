pipeline {
    agent any

    environment {
        IMAGE_NAME = "nisshaa/flask-app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Nisha-Velmurugan/deployment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'docker run --rm $IMAGE_NAME pytest || exit 1'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                withCredentials([string(credentialsId: 'ssh_pass', variable: 'PASS')]) {
                    sh '''
                        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no nishavelmurugan7@100.115.92.202 << 'EOF'
                        docker pull $IMAGE_NAME
                        docker stop flask-app || true
                        docker rm -f flask-app || true
                        docker run -d --name flask-app -p 5000:5000 $IMAGE_NAME
                        EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Pipeline Failed!'
        }
    }
}
