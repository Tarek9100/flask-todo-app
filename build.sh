#!/bin/bash

echo "Building the docker image for the flask app"
docker build -t flask-todo-app .
