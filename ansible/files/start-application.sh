#!/bin/bash
echo 'Fetching Docker Compose files for application from project'\''s bucket...'
sudo s3cmd get "$COMPOSE_FILES_BUCKET_PATH" /usr/local/app/ --recursive
if [ $? -ne 0 ]; then
  echo 'Failed to fetch files. Exiting...'
  exit 1
fi

echo 'Logging into AWS ECR...'
aws ecr get-login-password | docker login -u AWS --password-stdin "$ECR_BASE_URL"
if [ $? -ne 0 ]; then
  echo 'Docker failed to log into ECR. Exiting...'
  exit 1
fi

echo 'Pulling Docker images for application...'
docker-compose -f /usr/local/app/docker-compose.yml -f /usr/local/app/docker-compose.prod.yml pull
if [ $? -ne 0 ]; then
  echo 'Failed to pull images. Exiting...'
  exit 1
fi

# Run docker-compose to run application
echo 'Starting Docker Compose setup for application...'
docker-compose -f /usr/local/app/docker-compose.yml -f /usr/local/app/docker-compose.prod.yml up -d
if [ $? -ne 0 ]; then
  echo 'Failed to bring up application with docker-compose. Exiting...'
  exit 1
fi
