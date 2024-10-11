#!/bin/bash
echo "Pulling the latest Docker image..."
docker pull tarek910/flask-todo-app:latest

echo "Stopping and removing the existing container (if any)..."
docker stop flask-todo-app || true
docker rm flask-todo-app || true

echo "Deploying the new container..."
docker run -d -p 5001:5001 --name flask-todo-app tarek910/flask-todo-app:latest

echo "Deployment completed successfully! Application should be running on port 5001."

