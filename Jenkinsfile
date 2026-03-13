pipeline {
    agent any

    stages {

        stage('Preparation') {
            steps {
                deleteDir() // This wipes the directory at the start of every build
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-u root'
                }
            }
            steps {

                echo 'Installing system dependencies'

                sh '''
                apk add --no-cache python3 make g++
                '''

                echo 'Installing npm dependencies'

                sh '''
                PUPPETEER_SKIP_DOWNLOAD=true npm install
                '''
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-u root'
                }
            }
            steps {

                sh '''
                apk add --no-cache python3 make g++
                npm test
                '''
            }
        }

        stage('Containerize') {
            steps {

                sh '''
                docker build -t sittyan/todo-app:latest .
                '''
            }
        }

        stage('Push') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub_id',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push sittyan/todo-app:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker rmi sittyan/todo-app:latest || true'
        }
    }
}