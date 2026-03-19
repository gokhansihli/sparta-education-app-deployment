#!/bin/bash

sudo apt update -y

sudo apt upgrade -y

sudo apt install git -y

# Add the GPG key - GNU Privacy Guard, makes sure package is from Mongodb
# -fsSL fail silently, silent mode, show errors, follow redirects
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#Update the package list again
sudo apt update -y

# Install Mongodb
sudo apt install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh=2.1.5 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# `mongod --version` (You can check the version)(optional)

# `sudo systemctl status mongod` (check the status)

# cd /

# cd /etc

sudo nano mongod.conf

# Change bindIP to 0.0.0.0 in nano text

# cd

sudo systemctl start mongod

# If error happens, work below
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock    
sudo service mongod restart

sudo systemctl restart mongod
sudo systemctl status mongod

# Above is for second (mongodb) instance (We implemented above manualy, one by one)

################################################################################

# Below is for first EC2 instance

# in other terminal we did `pm2 kill` and below comments
# export DB_HOST=mongodb://108.129...215:27017/posts (se-yourname-db-2-tier)
# printenv DB_HOST (check if its working)
# cd se-sparta-test-app
# cd app
# sudo npm install
# node seeds/seed.js
# pm2 start app.js

# http://34.249...191/posts (se-yourname-app-2-tier)

# We first created EC2 instance (22,80,3000) and deployed app with improved-app-deploy.sh script
# Then we created second EC2 instance db (22, 27017) and implemented above script(above pm2 kill comment) then on the first terminal we connected db and app.