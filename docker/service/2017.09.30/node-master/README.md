all docker-stack.yml ( node-** except node-master ) file of all node should be located in this node ( node-master )
then execute sequentially
1. common-stack.yml
2. docker-stack.yml ( node-db )
3. docker-stack.yml ( node-sub )
5. docker-stack.yml ( node-nginx )
6. monitor-stack.yml
7. then build services on jenkins
