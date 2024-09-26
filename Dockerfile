pipeline {
    agent any

    environment {
        DOCKER_HOST = "tcp://10.0.0.186:2375" // Remote Docker API URL
    }

    stages {
        stage('Pull Nginx Image') {
            steps {
                script {
                    // Pull the latest Nginx image from Docker Hub on the remote Docker host
                    sh "docker -H $10.0.0.186 pull nginx"
                }
            }
        }

        stage('Stop and Remove Existing Container') {
            steps {
                script {
                    // Stop and remove any running Nginx container on the remote Docker host
                    sh "docker -H $10.0.0.186 stop nginx-container || true"
                    sh "docker -H $10.0.0.186 rm nginx-container || true"
                }
            }
        }

        stage('Run Nginx Container') {
            steps {
                script {
                    // Run a new Nginx container on the remote Docker host
                    sh "docker -H $10.0.0.186 run -d --name nginx-container -p 8080:80 nginx"
                }
            }
        }
    }

    post {
        success {
            echo "Nginx has been successfully deployed to the remote Docker host!"
        }
        failure {
            echo "Failed to deploy Nginx on the remote Docker host."
        }
    }
}
