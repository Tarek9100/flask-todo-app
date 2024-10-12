#!/bin/bash

PEM_PATH="./../gs-test2.pem"  
LOCAL_PATH="./" 
REMOTE_PATH="/home/ubuntu/flask-todo-app"  
EC2_IP="18.185.174.159" 
USERNAME="ubuntu"  

# 1. Transfer Code to Remote VM using SCP
echo "Transferring code to remote VM..."
scp -i $PEM_PATH -r $LOCAL_PATH $USERNAME@$EC2_IP:$REMOTE_PATH

# 2. SSH into Remote VM and build Docker image
echo "SSHing into remote VM and building Docker image..."
ssh -i $PEM_PATH $USERNAME@$EC2_IP << EOF
  cd $REMOTE_PATH
  echo "Building Docker image..."
  docker build -t flask-todo-app .

  echo "Stopping and removing any existing container..."
  docker stop flask-todo-app || true
  docker rm flask-todo-app || true

  echo "Running the Docker container..."
  docker run -d -p 5000:5000 flask-todo-app

  echo "Deployment completed successfully!"
EOF

echo "Script finished successfully!"
