``` yml
version: '2'
services:
  mariadb:
    image: mariadb
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=0000
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/mariadb/mariadb_data:/var/lib/mysql
    networks:
      network-infra:
        ipv4_address: 10.10.200.1
    command:
      - "mysqld"
      - "--character-set-server=utf8mb4"
      - "--collation-server=utf8mb4_unicode_ci"
    container_name: mariadb
  jenkins:
    image: jenkins
    ports:
      - "89:8080"
    environment:
      - TZ=Asia/Seoul
    env_file:
      - ./server-node-1/env/db.env
    volumes:
      - /home/jaehunpark/docker/service/jenkins/jenkins-data:/root
    networks:
      network-infra:
        ipv4_address: 10.10.200.9
    container_name: jenkins
  server-node-1:
    image: server-node-1
    environment:
      - TZ=Asia/Seoul
    env_file:
      - ./server-node-1/env/db.env
      - ./server-node-1/env/service.env
    volumes:
      - /home/jaehunpark/docker/service/server-node-1/server-node-1-data:/root
    tty: true
    depends_on:
      - mariadb
      - nginx
    networks:
      network-infra:
        ipv4_address: 10.10.200.3
    container_name: server-node-1
  server-java:
    image: server-java
    ports:
      - "88:8080"
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/server-java/server-java-data:/root
    tty: true
    depends_on:
      - mariadb
    container_name: server-java
  nginx:
    image: setyourmindpark/debian-nginx:apple
    ports:
      - "80:80"
      - "443:443"
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/nginx/nginx-data:/etc/nginx
    networks:
      network-infra:
        ipv4_address: 10.10.200.2
    container_name: nginx
  networks:
  network-infra:
    driver: bridge
    ipam:
      config:
        - subnet: 10.10.200.0/16
          gateway: 10.10.200.254
```

//http://stackoverflow.com/questions/39493490/provide-static-ip-to-docker-containers-via-docker-compose
//http://stackoverflow.com/questions/27937185/assign-static-ip-to-docker-container
//https://docs.docker.com/engine/reference/commandline/network_create/#description
//https://rafpe.ninja/2016/04/28/docker-compose-v2-using-static-network-addresses/
