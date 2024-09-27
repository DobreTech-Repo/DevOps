pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nginx'
        DOCKER_CONTAINER = 'mywebapp'
        REMOTE_HOST = '10.0.0.245'
        REMOTE_USER = 'dobre'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/Dobre237/dobrewebpage.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image locally on Jenkins server
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image to Remote Server') {
            steps {
                script {
                    // Save the image as a tar file, copy to remote server, and load it there
                    sh 'docker save ${DOCKER_IMAGE} | bzip2 | ssh ${REMOTE_USER}@${REMOTE_HOST} "bunzip2 | docker load"'
                }
            }
        }

        stage('Run Docker Container on Remote Server') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh '''
                    ssh ${REMOTE_USER}@${REMOTE_HOST} "
                    docker stop ${DOCKER_CONTAINER} || true &&
                    docker rm ${DOCKER_CONTAINER} || true &&
                    docker run -d --name ${DOCKER_CONTAINER} -p 80:80 ${DOCKER_IMAGE}
                    "'''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleanup if necessary...'
        }
    }
}
