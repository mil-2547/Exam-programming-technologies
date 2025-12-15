pipeline {
    agent none 

    environment {
        CCACHE_DIR       = '/ccache'
        CCACHE_BASEDIR   = "${WORKSPACE}"
        CCACHE_NOHASHDIR = 'true'
        CXX              = 'g++'
        DOCKER_IMAGE     = 'artiprice/exam'
        DOCKER_CREDS_ID  = 'dockerhub-creds'
    }

    triggers {
        cron('H/30 * * * *')
        pollSCM('H/10 * * * *')
    }

    stages {
        // --- GROUP 1: C++ COMPILATION (Runs in Container) ---
        stage('C++ Build & Test') {
            agent {
                docker {
                    image 'artiprice/my-gcc-ccache:latest'
                    args '''
                      -v ccache-vol:/ccache
                      -v $WORKSPACE/pch:/pch
                      -u root:root 
                    '''
                }
            }
            stages {
                stage('Check SCM') {
                    steps { checkout scm }
                }
                stage('Build Tests') {
                    steps { sh 'make build-tests' }
                }
                stage('Run Tests') {
                    steps {
                        sh 'build/bin/Test --gtest_output=xml:./build/test-results/tests.xml'
                    }
                    post {
                        always { junit 'build/test-results/tests.xml' }
                        success { echo 'Tests passed!' }
                        failure { echo 'Tests failed!' }
                    }
                }
                stage('Build Binary') {
                    steps {
                        sh 'make pch'
                        sh 'make all'
                    }
                }
                stage('Archive') {
                    steps {
                        archiveArtifacts artifacts: 'build/bin/crow_app', fingerprint: true
                    }
                }
            }
        }

        // --- GROUP 2: DOCKER IMAGE BUILD (Runs on Host) ---
        stage('Docker Packaging') {
            agent any 
            
            stages {
                stage('Build Docker Image') {
                    steps {
                        script {
                            sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                            sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                        }
                    }
                }
                stage('Push to Docker Hub') {
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: DOCKER_CREDS_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                                sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                                sh "docker push ${DOCKER_IMAGE}:latest"
                            }
                        }
                    }
                }
                stage('Cleanup') {
                    steps {
                        sh "docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER} || true"
                        sh "docker rmi ${DOCKER_IMAGE}:latest || true"
                    }
                }
            }
        }
    }
}
