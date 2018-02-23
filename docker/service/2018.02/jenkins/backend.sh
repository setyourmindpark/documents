# env ------------------------------------------------------------------------------------------------------------------------
DOCKER_REGISTRY_PROTOCOL=https
DOCKER_REGISTRY_DOMAIN=setyourmindpark
DOCKER_REGISTRY_PORT=5000
DOCKER_REGISTRY_USER=setyourmindpark
DOCKER_REGISTRY_PASSWD=0000

APP_NAME=setyourmindpark_backend
SERVICE_NAME=setyourmindpark_service_backend
APP_VERSION=`date +"%y%m%d%H%M%S"`

# build ------------------------------------------------------------------------------------------------------------------------
docker build --tag $APP_NAME:$APP_VERSION .
docker login -u $DOCKER_REGISTRY_USER -p $DOCKER_REGISTRY_PASSWD $DOCKER_REGISTRY_DOMAIN:$DOCKER_REGISTRY_PORT
docker tag $APP_NAME:$APP_VERSION $DOCKER_REGISTRY_DOMAIN:$DOCKER_REGISTRY_PORT/$APP_NAME:$APP_VERSION
docker push $DOCKER_REGISTRY_DOMAIN:$DOCKER_REGISTRY_PORT/$APP_NAME:$APP_VERSION
docker rmi -f $APP_NAME:$APP_VERSION
docker rmi -f $DOCKER_REGISTRY_DOMAIN:$DOCKER_REGISTRY_PORT/$APP_NAME:$APP_VERSION

docker service update \
   --image $DOCKER_REGISTRY_DOMAIN:$DOCKER_REGISTRY_PORT/$APP_NAME:$APP_VERSION \
   --with-registry-auth \
   $SERVICE_NAME
