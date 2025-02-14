pipeline {
    agent any

    environment {
        IMAGE_NAME = "nisshaa/flask-app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/nishavelmurugan7/flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'docker run --rm $IMAGE_NAME pytest'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh 'docker push $IMAGE_NAME'
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
                        docker rm flask-app || true
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
