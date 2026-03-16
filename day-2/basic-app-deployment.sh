#!/bin/bash

# update packages
sudo apt update -y

# upgrade packages
sudo apt upgrade -y

# install git if it's not there
sudo apt install git -y

# get the app code
git clone https://github.com/LSF970/se-sparta-test-app.git

# install nginx

sudo apt install nginx -y

# restart nginx
sudo systemctl restart nginx

# enable --> makes the process a startup process
sudo systemctl enable nginx

# install curl
sudo apt install curl -y

# download nodejs 20.x
sudo bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -"

# install nodejs 20
sudo apt install nodejs -y

# cd into repo
cd se-sparta-test-app

# cd into app folder
cd app

# npm install
sudo npm install

# start the app
npm start app.js