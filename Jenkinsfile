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

 // 5. 쿠버네티스 배포 작업
        stage('K8S Manifest Update') {
            steps {
                sh "ls"
                sh 'mkdir -p gitOpsRepo'
                dir("gitOpsRepo")
                {
                    git branch: "main",
                    credentialsId: githubCredential,
                    url: 'https://github.com/moonjukhim/kube-manifest.git' 
                    sh "git config --global user.email moonju.khim@gmail.com"
                    sh "git config --global user.name moonjukhim"
                    sh "cp kube-manifests/deployments.yaml gitOpsRepo/"
                    sh "cp kube-manifests/service.yaml gitOpsRepo/"
                    // 배포될 때 마다 버전이 올라야 하므로 deployment.yaml 에서 ksw7734/docker:버전 을 sed
                    // -i 로 ${currentBuild.number} 변수를 이용해 변경
                    sh "sed -i 's/docker:.*\$/docker:${currentBuild.number}/' deployment.yaml"
                    sh "git add deployment.yaml"
                    sh "git commit -m '[UPDATE] k8s ${currentBuild.number} image versioning'"
                    
                    withCredentials([gitUsernamePassword(credentialsId: githubCredential,
                                     gitToolName: 'git-tool')]) {
                        sh "git remote set-url origin https://github.com/moonjukhim/kube-manifest"
                        sh "git push -u origin main"
                    }
                }
            }
            post {
                    failure {
                      echo 'K8S Manifest Update failure !'
                    }
                    success {
                      echo 'K8S Manifest Update success !'
                    }
            }
        }

    }
}