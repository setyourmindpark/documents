
#### my.cnf
``` bash
...
## cluster config
log-bin=binlog
relay-log=relaylog
log-slave_updates=1
server-id=1
## cluster config
...
```

#### command
```
$ mysql -u root -p
mysql > SHOW MASTER STATUS;
mysql > STOP SLAVE;
mysql > CHANGE MASTER TO
        master_host = 'master ip',
        master_user = 'user',
        master_password = 'password',
        master_log_file = 'log_file',
        master_log_pos = log_pos;
mysql > START SLAVE;
mysql > SHOW SLAVE STATUS \G

mysql > create database service;
mysql > grant all privileges on service.* to jaehunpark@'%' identified by '0000' with grant option; # 특정데이터베이스에 생성유저 모든권한주기, 모든 외부ip 접속 허용
mysql > create user 'jaehunpark'@'%' identified by '0000'; # 일반계정생성, 모든 외부 ip 접속허용
mysql > drop user jaehunpark; => 삭제시

```
