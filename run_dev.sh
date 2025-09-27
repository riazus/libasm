#!/bin/bash

# Name of the image and container
IMAGE_NAME=libasm-dev
CONTAINER_NAME=libasm-container

# Build the image if not built yet
if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
  echo "Building Docker image..."
  docker build -f Dockerfile.dev -t $IMAGE_NAME .
fi

# Check if container exists
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "Container is already running. Attaching..."
        docker exec -it $CONTAINER_NAME bash
    else
        echo "Starting existing container..."
        docker start -ai $CONTAINER_NAME
    fi
else
    echo "Creating and starting new container..."
    docker run -it --name $CONTAINER_NAME \
      -v "$(pwd)":/work \
      -w /work \
      $IMAGE_NAME bash
fi

