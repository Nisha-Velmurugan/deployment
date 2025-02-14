pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-creds')
        IMAGE_NAME = "nisshaa/deployment"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Nisha-Velmurugan/deployment.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'docker run --rm -e PYTHONPATH=/app -w /app nisshaa/deployment:latest pytest tests/'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy Application') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ssh-password', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    sshpass -p "$PASS" ssh $USER@192.168.1.100 '
                    cd ~/deployment &&
                    docker-compose pull &&
                    docker-compose up -d --remove-orphans
                    '
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}. Check Jenkins logs for details."
        }
    }
}
