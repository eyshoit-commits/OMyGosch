#!/bin/bash

# Setup script for Docker, Docker Compose, and Dockge on Debian
# Run with: bash setup-dockge.sh

set -e  # Exit on error

echo "Updating package list..."
sudo apt update

echo "Installing Docker..."
sudo apt install -y docker.io

echo "Installing Docker Compose..."
sudo apt install -y docker-compose

echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Adding user to docker group..."
sudo usermod -aG docker $USER

echo "Creating directories for stacks and Dockge..."
sudo mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

echo "Downloading Dockge compose.yaml..."
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

echo "Starting Dockge server..."
docker compose up -d

echo "Dockge is now running. Access it at: http://<your-instance-ip>:5001"

echo "Setup complete!"