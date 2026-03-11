#!/bin/bash

# Update package
sudo apt update -y

# Upgrade packages
sudo apt upgrade - y

# Install nginx web server
sudo apt install nginx -y

# Restart nginx
sudo systemctl restart nginx

# Enable nginx as a startup process
sudo systemctl enable