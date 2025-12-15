pipeline {
    agent {
        docker {
            image 'artiprice/my-gcc-ccache:latest'
            args '''
              -v ccache-vol:/ccache
              -v $WORKSPACE/pch:/pch
            '''
        }
    }

    environment {
        CCACHE_DIR       = '/ccache'
        CCACHE_BASEDIR   = "${WORKSPACE}"
        CCACHE_NOHASHDIR = 'true'
        CXX              = 'g++'
        DOCKER_IMAGE     = 'artiprice/exam'
        DOCKER_CREDS_ID  = 'dockerhub-creds'
    }

    stages {
        stage('Check SCM') {
            steps {
                checkout scm
            }
        }
		stage('Build Tests') {
            steps {
                sh 'make build-tests'
            }
        }
		stage('Run Tests') {
			steps {
				sh 'build/bin/Test --gtest_output=xml:./build/test-results/tests.xml'
			}
			post {
				always {
					junit 'build/test-results/tests.xml'
				}
				success {
					echo 'application testing successfully completed'
				}
				failure {
					echo 'Oh nooooo!!! Tests failed!'
				}
			}
		}
        stage('Build') {
            steps {
                sh 'make pch'
                sh 'make all'
                sh 'ccache -s'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'build/bin/crow_app', fingerprint: true
            }
        }
        stage('Install docker') {
            steps {
                sh '''
					apt-get update && apt-get install -y --no-install-recommends docker.io
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
