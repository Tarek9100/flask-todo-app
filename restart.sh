#!/bin/bash

echo "Stopping and removing container"
docker stop flask-todo-app
docker rm flask-todo-app

echo "Starting a new container"

docker run -d -p 5000:5000 --name flask-todo-app flask-todo-app
echo "Waiting for container to start..."
sleep 5