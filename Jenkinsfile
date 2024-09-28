pipeline {
    agent any

    environment {
        DOCKER_HOST = 'dobre@10.0.0.245'  // Remote Docker host IP and user
        CONTAINER_NAME = 'nginx-container'
        IMAGE = 'nginx:latest'
        GIT_REPO = 'https://github.com/Dobre237/dobrewebpage.git'
    }

    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    // Clone the web page repository
                    git url: "${GIT_REPO}", branch: 'master'
                }
            }
        }

        stage('Pull NGINX Image') {
            steps {
                script {
                    // Pull NGINX Docker image on the remote Docker host
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                    'docker pull ${IMAGE}'
                    """
                }
            }
        }

        stage('Deploy NGINX with Web Content') {
            steps {
                script {
                    // Copy the web content to the remote server
                    sh """
                    scp -o StrictHostKeyChecking=no -r * ${DOCKER_HOST}:/tmp/webcontent
                    """

                    // Run NGINX container on the remote host with mounted web content
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                    'docker run -d --name ${CONTAINER_NAME} -p 80:80 -v /tmp/webcontent:/usr/share/nginx/html:ro ${IMAGE}'
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
                // Optional: Stop and remove the container and cleanup files after job completion
                sh """
                ssh -o StrictHostKeyChecking=no ${DOCKER_HOST} \\
                'docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME} && rm -rf /tmp/webcontent'
                """
            }
        }
    }
}
