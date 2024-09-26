pipeline {
    agent any

    environment {
        REMOTE_HOST = '10.0.0.186'          // IP address of the remote Docker host
        CONTAINER_NAME = 'nginx-container'   // Name of the Nginx container
        SSH_CREDENTIALS = 'your-ssh-credentials-id' // Jenkins SSH credentials ID
    }

    stages {
        stage('Pull Nginx Image on Remote Host') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {  // Use SSH credentials
                        // Pull the Nginx image from Docker Hub on the remote host
                        sh "ssh -o StrictHostKeyChecking=no dobre@$REMOTE_HOST 'docker pull nginx'"
                    }
                }
            }
        }

        stage('Stop and Remove Existing Container') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {  // Use SSH credentials
                        // Stop and remove the existing Nginx container if it exists
                        sh "ssh -o StrictHostKeyChecking=no dobre@$REMOTE_HOST 'docker stop $CONTAINER_NAME || true'"
                        sh "ssh -o StrictHostKeyChecking=no dobre@$REMOTE_HOST 'docker rm $CONTAINER_NAME || true'"
                    }
                }
            }
        }

        stage('Run Nginx Container on Remote Host') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {  // Use SSH credentials
                        // Run the Nginx container on the remote host, mapping port 8080 to 80
                        sh "ssh -o StrictHostKeyChecking=no dobre@$REMOTE_HOST 'docker run -d --name $CONTAINER_NAME -p 8080:80 nginx'"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Nginx successfully deployed on the remote Docker host!"
        }
        failure {
            echo "Failed to deploy Nginx on the remote Docker host."
        }
    }
}
