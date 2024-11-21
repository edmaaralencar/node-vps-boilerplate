
#!/bin/bash

set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

ADMIN_USER="admin"
ADMIN_PASSWORD="admin" 
echo "Creating a new user: $ADMIN_USER"
sudo useradd -m -s /bin/bash "$ADMIN_USER"
echo "$ADMIN_USER:$ADMIN_PASSWORD" | sudo chpasswd

echo "Adding $ADMIN_USER to sudo group..."
sudo usermod -aG sudo "$ADMIN_USER"
su - admin

echo "Installing Docker..."
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Starting and enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding $ADMIN_USER to the Docker group..."
sudo usermod -aG docker "$ADMIN_USER"
newgrp docker

echo "Verifying installations..."
docker --version
docker-compose --version

echo "Setup complete. User '$ADMIN_USER' created, and Docker + Docker Compose installed."
