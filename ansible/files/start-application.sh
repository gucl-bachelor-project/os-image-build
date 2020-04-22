#!/bin/bash
while getopts ":r:c:" opt; do
  case $opt in
  r)
    REGISTRY_URL="$OPTARG"
    ;;
  \?)
    echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Log into AWS ECR
aws ecr get-login-password | docker login -u AWS --password-stdin $REGISTRY_URL
if [ $? -ne 0 ]; then
  echo 'Docker failed to log into ECR. Exiting...'
  exit 1
fi

# Pull Docker images for service
docker-compose -f /usr/local/app/docker-compose.yml -f /usr/local/app/docker-compose.prod.yml pull
if [ $? -ne 0 ]; then
  echo 'Failed to pull images. Exiting...'
  exit 1
fi

# Run docker-compose to run service
docker-compose -f /usr/local/app/docker-compose.yml -f /usr/local/app/docker-compose.prod.yml up -d
if [ $? -ne 0 ]; then
  echo 'Failed to bring up application with docker-compose. Exiting...'
  exit 1
fi
