pipeline {
    agent any

    environment {
        DOCKER_HOST = "tcp://10.0.0.186:2375" // Docker Remote API
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                // Clone the GitHub repository
                git branch: 'main', url: 'https://github.com/Dobre237/dobrewebpage.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image for the app
                    dockerImage = docker.build("nginx")
                }
            }
        }

        stage('Deploy on Remote Docker') {
            steps {
                script {
                    // Stop any running container
                    try {
                        sh "docker -H tcp://10.0.0.186:2375 stop my-container || true"
                        sh "docker -H tcp://10.0.0.186:2375 rm my-container || true"
                    } catch (Exception e) {
                        echo "No existing container to stop."
                    }
                    
                    // Run the container on the remote Docker server
                    dockerImage.run('-d --name my-container -p 8080:80')
                }
            }
        }
    }

    post {
        success {
            echo 'Deployed successfully to remote Docker server.'
        }
        failure {
            echo 'Failed to deploy.'
        }
    }
}

