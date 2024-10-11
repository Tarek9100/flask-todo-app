#!/bin/bash

echo "Running docker container from flask-todo-app image"
sudo docker run -d -p 5001:5001 --name flask-todo-app flask-todo-app

