#!/bin/bash

source ./docker-version.sh

echo "Pushing $IMAGE_NAME"
docker push $IMAGE_NAME


