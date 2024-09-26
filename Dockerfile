pipeline {
    agent any

    environment {
        DOCKER_HOST = "tcp://10.0.0.186:2375" // Docker remote host API
    }

    stages {
        stage('Pull Nginx Image') {
            steps {
                script {
                    // Pull the Nginx Docker image
                    docker.image('nginx').pull()
                }
            }
        }

        stage('Run Nginx on Remote Server') {
            steps {
                script {
                    // Run the Nginx container on the remote server
                    docker.image('nginx').run('-d -p 8080:80')
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}