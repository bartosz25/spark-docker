#!/bin/bash
CONTAINER_NAME="$1"; 
CURRENT_DIR="$2"

echo "Removing old container if exists";
docker rmi $CONTAINER_NAME;



echo "Building new image";
docker build -f $CURRENT_DIR/Dockerfile . -t $CONTAINER_NAME;
echo "Creating new runnable container";