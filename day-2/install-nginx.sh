#!/bin/bash

# Update packages
sudo apt update -y

# Upgrade packages
sudo apt upgrade -y

# Install NGINX web server
sudo apt install nginx -y

# Restart NGINX
sudo systemctl restart nginx

# Enable NGINX as a startup process
sudo systemctl enable nginx