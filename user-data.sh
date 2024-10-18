#!/bin/bash
# Update the package repository
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the user to the Docker group for permissions
sudo usermod -aG docker ubuntu

# Install Git to clone the repository
sudo apt-get install -y git

# Clone your repository
git clone https://github.com/Tarek9100/flask-todo-app.git

# Navigate to the application directory
cd flask-todo-app

# Stop and remove any existing container
sudo docker stop flask-todo-app || true
sudo docker rm flask-todo-app || true

# Build and run the Docker containers
sudo docker compose up --build -d

echo "Deployment completed successfully!"
