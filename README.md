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

2.

```bash
sudo docker run -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock  -p 8080:8080 -p 50000:50000 --restart=on-failure --name jenkins-server jenkins/jenkins:lts-jdk11

sudo docker ps
# sudo docker rm [dockerid]

sudo docker logs jenkins-server
# copy password from log 950abf21efaa405da6264221a432a73e
```

3. Jenkins 접속 및 설정

```bash
# https://velog.io/@gobeul/Docker-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88%EB%A1%9C-Jenkins-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0
# docker exec -itu 0 {컨테이너 이름} /bin/bash
sudo docker exec -itu 0 jenkins-server /bin/bash

jenkins에도 docker 클라이언트가 필요하기때문에 같이 설치해준다.
docker exec jenkins-server apt update
docker exec jenkins-server apt install -y docker.io
sudo chmod 777 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# #
env
# JAVA_HOME=/opt/java/openjdk
```

4. Jenkins credential 설정

   https://jenakim47.tistory.com/73

   - Developer settings > Personal access tokens > 생성
   - jenkins에서 두개의 credential 생성
   - Secret text / secret / id(github-token)

5.
