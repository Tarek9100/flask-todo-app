#!/bin/bash

echo "Stopping and removing container"
sudo docker stop flask-todo-app
sudo docker rm flask-todo-app
echo "Clean-up complete!"
