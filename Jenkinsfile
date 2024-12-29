pipeline{
    agent any

    environment {
        dockerHubRegistry = 'moonjukhim/docker' // dockerHub에 repository 명
        dockerHubRegistryCredential = 'docker-hub-id' // Jenkins에서 생성한 dockerhub-credential-ID값
        githubCredential = 'jenkins-github-id' // Jenkins에서 생성한 github-credential-ID값
        PATH = "/usr/local/bin:${env.PATH}"
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
    stage('docker image build & push'){
        steps{
            script{
                docker.withRegistry('https://registry.hub.docker.com', dockerHubRegistryCredential) {
                    def app = docker.build(${dockerHubRegistry}:${currentBuild.number})
                    app.push()
                }
            }
            
            /* sh "docker --version" */
            /* sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}" */
            /* sh "docker build . -t ${dockerHubRegistry}:latest" */
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