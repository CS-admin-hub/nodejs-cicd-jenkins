#!/bin/bash
set -e

# Configuration
CONTAINER_NAME="golden-cicd-nodejs-app"
IMAGE_NAME="golden-cicd-nodejs"
APP_ENV="${APP_ENV:-local}"
PORT="${PORT:-3000}"

echo "🚀 Starting deployment..."
echo "Environment: $APP_ENV"

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🛑 Stopping existing container..."
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Run new container
echo "🐳 Starting new container..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:3000 \
    -e APP_ENV=$APP_ENV \
    -e NODE_ENV=production \
    $IMAGE_NAME

echo "✅ Deployment complete!"
echo "Container is running on port $PORT"

# Wait for container to be healthy
echo "⏳ Waiting for health check..."
sleep 3

# Verify health endpoint
if curl -f http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "❌ Health check failed!"
    exit 1
fi
