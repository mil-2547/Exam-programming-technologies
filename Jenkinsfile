pipeline {
    agent {
        docker {
            image 'alpine:3.21'
			      args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
  
    environment {
        DOCKER_IMAGE     = 'artiprice/my-gcc-ccache'
        DOCKER_CREDS_ID  = 'dockerhub-credentials'
    }

    options {
        timestamps()
    }

    stages {
        stage('Check SCM') {
            steps {
                checkout scm
            }
        }
        stage('Install docker') {
            steps {
                sh '''
                    apk add --no-cache docker
                '''
            }
        }
		    stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                    sh 'docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest'
				        }
            }
        }
		    stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDS_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh 'docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                        sh 'docker push ${DOCKER_IMAGE}:latest'
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh 'docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER} || true'
                sh 'docker rmi ${DOCKER_IMAGE}:latest || true'
             }
        }
    }
}
