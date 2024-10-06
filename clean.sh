#!/bin/bash

echo "Stopping and removing container"
docker stop flask-todo-app
docker rm flask-todo-app
echo "Clean-up complete!"