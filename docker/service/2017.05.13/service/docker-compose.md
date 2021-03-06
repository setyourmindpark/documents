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
  server-node-1:
    image: server-node
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/server-node/server-node-1-volume:/root
    depends_on:
      - mariadb
    networks:
      network-infra:
        ipv4_address: 10.10.200.3
    container_name: server-node-1
  server-node-2:
    image: server-node
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/server-node/server-node-2-volume:/root
    depends_on:
      - mariadb
    networks:
      network-infra:
        ipv4_address: 10.10.200.4
    container_name: server-node-2
  server-java:
    image: server-java
    ports:
      - "88:8080"
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/server-java/server-java-data:/root
    networks:
      network-infra:
        ipv4_address: 10.10.200.8
    depends_on:
      - mariadb
    container_name: server-java
  nginx:
    image: setyourmindpark/debian-nginx
    ports:
      - "80:80"
      - "443:443"
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/nginx/nginx-volume:/etc/nginx
    depends_on:
      - server-node-1
      - server-node-2
    networks:
      network-infra:
        ipv4_address: 10.10.200.2
    container_name: nginx
  rabbitmq:
    image: rabbitmq
    ports:
      - "15672:15672"
    environment:
      - TZ=Asia/Seoul
    volumes:
      - /home/jaehunpark/docker/service/rabbitmq/rabbitmq-volume:/var/lib/rabbitmq
    networks:
      network-infra:
        ipv4_address: 10.10.200.7
    container_name: rabbitmq
networks:
  network-infra:
    driver: bridge
    ipam:
      config:
        - subnet: 10.10.200.0/16
          gateway: 10.10.200.254                             
```
