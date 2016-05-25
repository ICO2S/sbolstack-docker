#!/bin/bash

source ./docker-version.sh

echo "Building $IMAGE_NAME"
docker build -t $IMAGE_NAME .


