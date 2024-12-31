pipeline{
    agent any

    environment {
        dockerHubRegistry = 'moonjukhim/docker'         // dockerHub의 repository 명
        dockerHubRegistryCredential = 'jenkins-dockerhub-id'   // Jenkins에서 생성한 dockerhub-credential-ID값
        githubCredential = 'jenkins-github-id'          // Jenkins에서 생성한 github-credential-ID값
        PATH = "/usr/local/bin:${env.PATH}"
    }

// 1. git repository check
    stages {
        stage('check out application git branch'){
            steps {
                checkout scm
            }
            post {
                failure {
                    echo 'repository checkout failure'
                }
                success {
                    echo 'repository checkout success'
                }
            }
        }

// 3. Docker Image build 
        stage('docker image build'){
            steps{
                sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
                sh "docker build . -t ${dockerHubRegistry}:latest"
            }
            post {
                    failure {
                      echo 'Docker image build failure !'
                    }
                    success {
                      echo 'Docker image build success !'
                    }
            }
        }

// 3. Docker Image push
        stage('Docker Image Push') {
            steps {
                echo "Push Docker"
                script{
                    withDockerRegistry([ credentialsId: dockerHubRegistryCredential, url: "" ]) {
                        sh "docker images"

                        sh "docker push ${dockerHubRegistry}:${currentBuild.number}"  
                        sh "docker push ${dockerHubRegistry}:latest" 
                        sleep 10 /* Wait uploading */
                    }
                }
            }
            post {
                    failure {
                      echo 'Docker Image Push failure !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
                    success {
                      echo 'Docker image push success !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
            }
        }

    }
}