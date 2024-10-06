#!/bin/bash

echo "Running docker container from flask-todo-app image"
sudo docker run -d -p 5000:5000 --name flask-todo-app flask-todo-app

