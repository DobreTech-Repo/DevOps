pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = '10.0.0.245'  // Remote Docker host IP
        CONTAINER_NAME = 'nginx-container'
        IMAGE = 'nginx:latest'  // Public image from Docker Hub
        GIT_REPO = 'https://github.com/Dobre237/dobrewebpage.git'  // Your GitHub repository
        SSH_CREDENTIALS_ID = '2244'  // Replace with your Jenkins SSH credential ID
    }

    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    // Clone the web page repository
                    git url: "${GIT_REPO}", branch: 'main'
                }
            }
        }

        stage('Pull NGINX Image') {
            steps {
                script {
                    // Use SSH credentials to pull the NGINX image on the remote Docker host
                    withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS_ID, usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
                        sh """
                        sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                        'docker pull ${IMAGE}'
                        """
                    }
                }
            }
        }

        stage('Deploy NGINX with Web Content') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS_ID, usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
                        // Copy the cloned web content to the remote server
                        sh """
                        sshpass -p ${SSH_PASS} scp -o StrictHostKeyChecking=no -r * ${SSH_USER}@${DOCKER_HOST_IP}:/tmp/webcontent
                        """

                        // Run NGINX container on the remote host with mounted web content
                        sh """
                        sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                        'docker run -d --name ${CONTAINER_NAME} -p 80:80 -v /tmp/webcontent:/usr/share/nginx/html:ro ${IMAGE}'
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Check if the container is running on the remote Docker host
                withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS_ID, usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
                    sh """
                    sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                    'docker ps -f name=${CONTAINER_NAME}'
                    """
                }
            }
        }
        cleanup {
            script {
                // Optional cleanup to stop and remove the container after job completion
                withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS_ID, usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
                    sh """
                    sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                    'docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME} && rm -rf /tmp/webcontent'
                    """
                }
    
