``` yml
version: '2'
services:
  jenkins:
    image: jenkins
    ports:
      - "89:8080"
    environment:
      - TZ=Asia/Seoul
    env_file:
      - ../server-node/service.env
    volumes:
      - /home/jaehunpark/docker/service/jenkins/jenkins-data:/root
    container_name: jenkins

```
