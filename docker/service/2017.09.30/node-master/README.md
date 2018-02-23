#### label update
docker node update --label-add type=db node-db1   
docker node update --label-add type=db node-db2   
docker node update --label-add type=backend node-backend1  
docker node update --label-add type=backend node-backend2  
docker node update --label-add type=backend node-backend3  


#### All docker-stack.yml file of all node should be located in this node ( node-master )
##### then execute sequentially  
1. common-stack.yml ( node-master )
2. monitor-stack.yml ( node-master )
3. docker-stack.yml ( node-log )
4. docker-stack.yml ( node-db )
5. docker-stack.yml ( node-redis )
6. docker-stack.yml ( node-backend )
7. docker-stack.yml ( node-nginx )
8. then build services on jenkins  
