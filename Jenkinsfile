pipeline{
    agent any

    environment {
        dockerHubRegistry = 'moonjukhim/docker' // dockerHub에 repository 명
        dockerHubRegistryCredential = 'DockerHubID' // Jenkins에서 생성한 dockerhub-credential-ID값
        githubCredential = 'jenkins-git-id' // Jenkins에서 생성한 github-credential-ID값
    }
// 1. git repository 가 체크되는지 확인, 제대로 연동이 안될 경우, 이 단계(stage) 에서 fail 발생
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

// 3. Dockefile build 
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
    }
}