#!/bin/bash

echo "Building the docker image for the flask app"
sudo docker build -t flask-todo-app .
