1. Google Kubernetes Engine 생성

```bash
terraform init
terraform plan
terraform apply
```

1. Docker 설치

```bash
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

2. 컨테이너를 이용한 Jenkins 시작

```bash
sudo docker run -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock  -p 8080:8080 -p 50000:50000 --restart=on-failure --name jenkins-server jenkins/jenkins:lts-jdk11

sudo docker ps
# sudo docker rm [dockerid]

sudo docker logs jenkins-server
# copy password from log af2a40b4425a4517abfb059f7a564ed5
```

3. Jenkins 접속 및 설정

````bash
# https://velog.io/@gobeul/Docker-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88%EB%A1%9C-Jenkins-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0
# docker exec -itu 0 {컨테이너 이름} /bin/bash

```bash
sudo docker exec -itu 0 jenkins-server /bin/bash

# jenkins에도 docker 클라이언트가 필요하기때문에 같이 설치해준다.
sudo docker exec -itu 0 jenkins-server apt update
sudo docker exec -itu 0 jenkins-server apt install -y docker.io
sudo chmod 777 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# #
env
# JAVA_HOME=/opt/java/openjdk
````

4. Jenkins에서 github credential 설정

   https://jenakim47.tistory.com/73

   - Developer settings > Personal access tokens > 생성
   - jenkins에서 두개의 credential 생성

     - Kind : Secret text
     - secret : [SECRET_VALUE]
     - id : github-token

   - jenkins에서 두개의 credential 생성
     - Kind : Username with password
     - username : moonjukhim
     - id : jenkins-github-id

5. Docker Hub credential 설정

   - Docker hub를 위한 credential 생성

     - Kind : Username with password
     - username : moonjukhim
     - id : jenkins-dockerhub-id

6. Jenkins Pipeline 생성

   - 새로운 item
   - Pipeline
     - Pipeline script from SCM
       - SCM : Git
         - Repository URL : https://github.com/moonjukhim/docker
         - Credentials : moonjukhim/jenkins-github-id
       - Branches to build
         - Branch : \*/main

7. Docker Pipeline Plugins 설치
