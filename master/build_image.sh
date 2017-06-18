#!/bin/bash

CONTAINER_NAME="$1";
CURRENT_DIR="$2"

echo "Removing old container if exists";
docker rmi $CONTAINER_NAME -f;

echo "Creating subnet";
docker network rm spark-network
docker network create --subnet=172.18.0.0/16 spark-network

echo "Building new image";
docker build -f $CURRENT_DIR/Dockerfile . -t $CONTAINER_NAME;