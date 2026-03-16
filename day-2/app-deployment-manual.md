## App deployment manual steps

Before you run these commands you must:

- Create an EC2 instance
  - It must have an SG that has ports 22, 80 and 3000 open
- Copy the app code as a zip to your EC2 instance, using SCP
  - example: `scp -i ~/.ssh/se-yourname-key-pair.pem "nodejs20-se-test-app-2025.zip" ubuntu@34.244.245.244:~`

If the above has been done, follow the following guide:

1. `sudo apt update -y`
   1. This downloads newest versions of packages
2. `sudo apt upgrade -y`
   1. This install latest version available
3. `sudo apt install unzip -y`
   1. Package for unzipping files
4. `sudo unzip nodejs20-se-test-app-2025.zip`
   1. Unzips app folder so it can be used
5. `sudo apt install nginx -y`
   1. Installs and runs nginx web server
   2. `sudo systemctl status nginx` to check server is running and ready
   3. "q" to return to normal terminal
6. `sudo bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -"`
   1. Get specific version of Nodejs downloaded (20)
   2. Not installed yet!
7. `sudo apt install nodejs -y`
   1. Installs nodejs 20
   2. `node -v` to check version
8. `cd se-test-app-2025`
   1. Go into folder we unzipped
9. `cd app`
   1. Go into folder that contains app code
10. `sudo npm install`
    1. Installs npm libraries needed for app to run properly
11. `npm start app.js`
    1. Starts app, runs in foreground
    2. Thus will take away terminal access
12. Check your public IP address to see if Sparta app is working
    1. e.g. `http://3.134.41.67:3000`
