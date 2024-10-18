#!/bin/bash

echo "Stopping containers"
docker compose down


echo "App Starting"

docker compose up --build
echo "Waiting for containers to start..."
sleep 5
