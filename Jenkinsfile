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

        stages {
        stage('Pull NGINX Image') {
            steps {
                script {
                    // Pulling NGINX Docker image from Docker Hub
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                    'docker pull ${IMAGE}'
                    """
                }
            }
        }

        stage('Deploy NGINX Container') {
            steps {
                script {
                    // Run the NGINX container on the remote Docker host
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                    'docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE}'
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                // Check if the container is running on the remote Docker host
                sh """
                ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                'docker ps -f name=${CONTAINER_NAME}'
                """
            }
        }
        cleanup {
            script {
                // Optional cleanup to stop and remove the container after job completion
                sh """
                ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                'docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}'
                """
            }
        }
    }
}
