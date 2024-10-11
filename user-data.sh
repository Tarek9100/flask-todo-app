#!/bin/bash
# Update the package repository
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose (optional)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Git to clone the repository
sudo apt-get install -y git

chmod +x deploy.sh
./deploy.sh
