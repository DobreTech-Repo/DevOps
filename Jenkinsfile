pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = '10.0.0.245'  // Replace with your remote Docker host IP
        CONTAINER_NAME = 'nginx-app'
        IMAGE = 'nginx:latest'  // Public nginx image from Docker Hub
        GIT_REPO = 'https://github.com/Dobre237/dobrewebpage.git'  // Your GitHub repository URL
        DEPLOY_DIR = '/tmp/webcontent'  // Directory on the remote host for web content
        SSH_CREDENTIALS_ID = '2244'  // Replace with your Jenkins SSH credentials ID
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

        stage('Deploy and Run NGINX') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS_ID, usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
                        // Create the deployment directory on the remote host
                        sh """
                        sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                        'mkdir -p ${DEPLOY_DIR}'
                        """

                        // Copy the web content to the remote host
                        sh """
                        sshpass -p ${SSH_PASS} scp -o StrictHostKeyChecking=no -r * ${SSH_USER}@${DOCKER_HOST_IP}:${DEPLOY_DIR}
                        """

                        // Pull the nginx image and run it
                        sh """
                        sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no ${SSH_USER}@${DOCKER_HOST_IP} \\
                        'docker pull ${IMAGE} && docker run -d --name ${CONTAINER_NAME} -p 8080:80 -v ${DEPLOY_DIR}:/usr/share/nginx/html:ro ${IMAGE}'
                        """
                    }
                }
            }
        }
    }
}
