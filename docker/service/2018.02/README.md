
## docker node update
``` bash
$ docker node update --label-add type=common [ common nodes id ]
$ docker node update --label-add type=db-failover [ db-failover nodes id ]
$ docker node update --label-add type=nginx [ nginx nodes id ]
$ docker node update --label-add type=backend [ backend nodes id ]
```

## deploy sequence
docker-stack.yml 에 모든 service 설정을 구성해도되지만 test 중 docker private registry에서 jenkins로 부터 service update된 backend와 같은 image가 가변적으로 변하는 service들은 image가 docker-stack.yml에 정의된 이미지로 돌아갈수도 있기에 service들을 쪼개는 방식으로 사용한다.  
각 service들은 stack 이름만 같다면 ( setyourmindpark_service ) stack에 자동으로 합쳐진다. ( $ docker stack ls )
``` bash
$ docker network create --driver overlay --attachable setyourmindpark_service_net  # --attachable option은 container 수동생성시( run ) 수동으로 --network setyourmindpark_service_net 붙여줄수있기위함. 
$ docker stack deploy -c db-failover-service.yml setyourmindpark_service
$ docker stack deploy -c backend-service.yml setyourmindpark_service
$ docker stack deploy -c nginx-service.yml setyourmindpark_service
```

## db replicas 설정 
https://setyourmindpark.github.io/2018/02/09/database-1/   

mysql 또는 mariadb의 db replication 에 대해서 살펴보려한다.  
서비스가 커지면서 db traffic에 대한 이슈, 또는 데이터 장애에 대한 대비책으로 replication 가 갖는 이점들이 분명 존재한다.  
하지만 db replication 를 한다고 해서 무조건 좋은것은 아니며 그만큼 관리가 힘든 부분도 존재하는것 같다.  
이전에 설치한 [setup mariadb](https://setyourmindpark.github.io/2018/02/02/database/) 롤 통해 replication 를 진행해보려한다.  

## config
replication 를 하기위해 2대의 db로 테스트를 진행하며, 필자는 양방향 replication으로 서로가 master 와 slave가 되는 방법으로 진행하려한다.  
먼저 db의 고유 server-id를 부여해야하며 db1에서 다음과 같이 설정하였다.  
``` bash
# db1 shell
$ vi /etc/my.cnf

...
[mysqld]
## replication config
log-bin=binlog
relay-log=relaylog
log-slave_updates       # master에서 받아온 변경사항을 자신의 log에 기록
server-id=1             # 각 db는 반드시 고유한 server-id를 가져야한다.  
## replication config
...

$ service maridb restart
```

db2에서도 다음과 같이 진행하며 server-id 값만 다를뿐 다른 설정은 동일하다.  
``` bash
# db2 shell
$ vi /etc/my.cnf

...
[mysqld]
## replication config
log-bin=binlog
relay-log=relaylog
log-slave_updates       # master에서 받아온 변경사항을 자신의 log에 기록
server-id=2             # 각 db는 반드시 고유한 server-id를 가져야한다.  
## replication config
...

$ service maridb restart
```
db1의 log position을 확인한다.  
``` bash
# db1 shell
$ mysql > SHOW MASTER STATUS;
+---------------+----------+--------------+------------------+
| File          | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+---------------+----------+--------------+------------------+
| binlog.000001 |      325 |              |                  |
+---------------+----------+--------------+------------------+
```

db2에서 db1의 master 정보를 설정하여 db1을 db2의 master로 설정한다.  
slave가 된 db2를 시작한다.  
``` bash
# db2 shell
mysql > CHANGE MASTER TO
MASTER_LOG_FILE='binlog.000001',
MASTER_LOG_POS=325,
MASTER_HOST='db1 host',
MASTER_USER='db1 user',
MASTER_PASSWORD='db1 user password';
START SLAVE;
```
slave가 된 db2의 정보확인 
``` bash
# db2 shell
mysql > SHOW SLAVE STATUS\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
...                  
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
...
```
db2 가 db1을 master로 동작하는 slave로 된것을 확인할수있다.  
db1에서도 db2의 master 정보를 설정하여 db2을 db1의 master로 설정한다.  
db2의 log position을 확인한다.  
``` bash
# db2 shell
$ mysql > SHOW MASTER STATUS;
+---------------+----------+--------------+------------------+
| File          | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+---------------+----------+--------------+------------------+
| binlog.000001 |      325 |              |                  |
+---------------+----------+--------------+------------------+
```

db1에서 db2의 master 정보를 설정하여 db2을 db1의 master로 설정한다.  
slave가 된 db1를 시작한다.  
``` bash
# db1 shell
mysql > CHANGE MASTER TO
MASTER_LOG_FILE='binlog.000001',
MASTER_LOG_POS=325,
MASTER_HOST='db2 host',
MASTER_USER='db2 user',
MASTER_PASSWORD='db2 user password';
START SLAVE;
```
slave가 된 db1의 정보확인 
``` bash
# db1 shell
mysql > SHOW SLAVE STATUS\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
...                  
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
...
```
db1과 db2의 양방향 replication 설정이 완료되었다.  
참고로 필자는 replication을 하기전 사전에 양쪽db 모두 (db1, db2) 의 계정 정보를 사전에 생성, 권한부여 까지 마친 상태로 진행하였으며 position 초기화 후 진행하였다.   
``` bash
$ mysql > RESET MASTER;
```


## sync test
위의 설정대로라면 db1이나 db2의 어떤 쪽에서도 DDL 이나 DML이 발생할경우 양쪽db1 모두 sync가 되어 동기화가 이루어져야한다.  
``` bash
# db1 shell
$ mysql > create database test_db;

# db2 shell
$ mysql > show databases;
+--------------------+
| Database           |
+--------------------+
| ...                |
| test_db            |
| ...                |
+--------------------+
$ mysql > use test_db;
$ mysql > create table test_tbl( id int primary key );
$ mysql > insert into test_tbl values(1);

# db1 shell
$ mysql > use test_db;
$ select * from test_tbl;
+----+
| id |
+----+
|  1 |
+----+
```
양쪽모두 sync 가되어 정상적으로 동기화가 되는것을 확인할수있다.  

## position skip
장애가 일어난 상황에서 sync 가 깨진경우 master log position을 skip한후 slave 재시작하게되면 그동안 master에 쌓인 log가 slave에 반영된다.  
``` bash
$ mysql > STOP SLAVE;
$ mysql > SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1;
$ mysql > START SLAVE;
```