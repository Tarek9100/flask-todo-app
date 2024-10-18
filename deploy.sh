#!/bin/bash

PEM_PATH="./../gs-test2.pem"  
LOCAL_PATH="./" 
REMOTE_PATH="/home/ubuntu/flask-todo-app"  
EC2_IP="3.68.108.135" 
USERNAME="ubuntu"  

# Create a tarball of essential files while excluding unnecessary ones
echo "Creating an archive of the essential files..."
tar --exclude='.git' --exclude='node_modules' --exclude='venv' -czf flask-todo-app.tar.gz .

# 1. Transfer Code to Remote VM using SCP
echo "Transferring code to remote VM..."
scp -i $PEM_PATH flask-todo-app.tar.gz $USERNAME@$EC2_IP:/home/$USERNAME

# 2. SSH into Remote VM and build Docker image
echo "SSHing into remote VM and building Docker image..."
ssh -i $PEM_PATH $USERNAME@$EC2_IP << EOF
  # Ensure remote directory exists
  mkdir -p $REMOTE_PATH
  mv /home/$USERNAME/flask-todo-app.tar.gz $REMOTE_PATH
  cd $REMOTE_PATH
  tar -xzf flask-todo-app.tar.gz  # Extract the archive
  
  # Stop and remove existing container
  echo "Stopping and removing any existing container..."
  sudo docker stop flask-todo-app || true
  sudo docker rm flask-todo-app || true


  echo "Running the Docker containers..."
  sudo docker compose up --build
  echo "Deployment completed successfully!"
EOF

# Cleanup local archive
rm flask-todo-app.tar.gz

echo "Script finished successfully!"
