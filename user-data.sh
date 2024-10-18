#!/bin/bash
# Redirect output to a log file for debugging
exec > /var/log/user-data.log 2>&1
set -x

# Update the package repository
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose (Standalone Version 1.29.2)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the user to the Docker group for permissions
sudo usermod -aG docker ubuntu

# Install Git to clone the repository
sudo apt-get install -y git

# Clone your repository
cd /home/ubuntu
git clone https://github.com/Tarek9100/flask-todo-app.git

# Navigate to the application directory
cd flask-todo-app

# Ensure the ubuntu user owns the necessary files
sudo chown -R ubuntu:ubuntu /home/ubuntu/flask-todo-app

# Stop and remove any existing container
sudo docker-compose down || true

# Build and run the Docker containers
sudo docker-compose up --build -d

echo "Deployment completed successfully!"

# === SETTING UP THE BACKUP SCRIPT ===

# Create the backup script
cat << 'EOF' > /home/ubuntu/flask-todo-app/backup.sh
#!/bin/bash

# Navigate to the directory containing docker-compose.yml
cd /home/ubuntu/flask-todo-app

# Define variables
SERVICE_NAME="db"
BACKUP_DIR="/home/ubuntu/flask-todo-app/backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/postgres_backup_$DATE.sql.gz"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# Get the container ID of the 'db' service
CONTAINER_ID=$(docker-compose ps -q $SERVICE_NAME)

# Check if the container is running
if [ -z "$CONTAINER_ID" ]; then
  echo "Error: Unable to find running container for the '$SERVICE_NAME' service."
  exit 1
fi

# Run pg_dump inside the container and output to a compressed file on the host
docker exec -e PGPASSWORD=postgres $CONTAINER_ID \
  pg_dump -U postgres -d todoapp | gzip > $BACKUP_FILE

# Remove backups older than 7 days
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -exec rm {} \;

echo "Backup completed: $BACKUP_FILE"
EOF

# Make the backup script executable
chmod +x /home/ubuntu/flask-todo-app/backup.sh

# Ensure the cron service is started and enabled
sudo systemctl start cron
sudo systemctl enable cron

# Add the backup script to cron to run daily at 2 AM for the ubuntu user
sudo -u ubuntu crontab -l 2>/dev/null | { cat; echo "0 2 * * * /home/ubuntu/flask-todo-app/backup.sh >> /home/ubuntu/flask-todo-app/cron.log 2>&1"; } | sudo -u ubuntu crontab -
