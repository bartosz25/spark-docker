#!/bin/bash
CONTAINER_NAME="$1";
# IMAGE_NAME="spar_yarn_slave_image";
CURRENT_DIR="$2"

echo "Removing old container if exists";
docker rmi $CONTAINER_NAME;

# echo "Removing old image if exists";
# docker rm $IMAGE_NAME;


echo "Building new image";
docker build -f $CURRENT_DIR/Dockerfile . -t $CONTAINER_NAME;
echo "Creating new runnable container";
# --link spark_yarn_master => @see https://docs.docker.com/engine/userguide/networking/default_network/configure-dns/ --link spark_yarn_master:spar_yarn_master_image
# docker run --name $IMAGE_NAME -i -t  --hostname spark-slave -p 7177:7177  --net spark-network --ip 172.18.0.21 --add-host="spark-master:172.18.0.20" $CONTAINER_NAME

# TODO:
# 1. Spark master host can change ----> Find a way to fix it
