all docker-stack.yml file of all node should be located in this node ( node-master )
then execute sequentially
1. common-stack.yml
2. docker-stack.yml ( node-db )
3. docker-stack.yml ( node-sub )
5. docker-stack.yml ( node-nginx )
6. monitor-stack.yml
7. then build services on jenkins  



label update
docker node update --label-add type=db node-db1
docker node update --label-add type=db node-db2
docker node update --label-add type=backend node-backend1
docker node update --label-add type=backend node-backend2
docker node update --label-add type=backend node-backend3
