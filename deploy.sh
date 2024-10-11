#!/bin/bash

# Pull the latest Docker image from Docker Hub
echo "Pulling the latest Docker image..."
docker pull tarek910/flask-todo-app:latest

# Stop and remove the existing container if it exists
echo "Stopping and removing the existing container (if any)..."
docker stop flask-todo-app || true
docker rm flask-todo-app || true

# Run the new container with appropriate settings
echo "Deploying the new container..."
docker run -d \
  -p 5001:5001 \  # Map port 5001 on the host to 5001 on the container
  --restart unless-stopped \  # Restart the container unless manually stopped
  --name flask-todo-app \
  tarek910/flask-todo-app:latest

echo "Deployment completed successfully! Application should be running on port 5001."


