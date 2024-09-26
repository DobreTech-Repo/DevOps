pipeline {
    agent any

    environment {
        REMOTE_HOST = 'dobre@10.0.0.186'  // SSH login to the remote Docker host
        CONTAINER_NAME = 'nginx-container' // Name of the Nginx container
    }

    stages {
        stage('Test SSH Connection') {
            steps {
                script {
                    // Test SSH connection to the remote host
                    echo "Testing SSH connection to $REMOTE_HOST"
                    sh "ssh $REMOTE_HOST 'echo SSH connection successful'"
                }
            }
        }

        stage('Pull Nginx Image on Remote Host') {
            steps {
                script {
                    echo "Pulling Nginx image on $REMOTE_HOST"
                    // Pull the Nginx image from Docker Hub on the remote host using SSH
                    sh "ssh $REMOTE_HOST 'docker pull nginx'"
                }
            }
        }

        stage('Stop and Remove Existing Container') {
            steps {
                script {
                    echo "Stopping and removing existing Nginx container on $REMOTE_HOST"
                    // Stop and remove the existing Nginx container if it exists
                    sh "ssh $REMOTE_HOST 'docker stop $CONTAINER_NAME || true'"
                    sh "ssh $REMOTE_HOST 'docker rm $CONTAINER_NAME || true'"
                }
            }
        }

        stage('Run Nginx Container on Remote Host') {
            steps {
                script {
                    echo "Running Nginx container on $REMOTE_HOST"
                    // Run the Nginx container on the remote host, mapping port 8080 to 80
                    sh "ssh $REMOTE_HOST 'docker run -d --name $CONTAINER_NAME -p 8080:80 nginx'"
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
