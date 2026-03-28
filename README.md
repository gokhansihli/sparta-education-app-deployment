# App Deployment Skill Sprint — Notes

This repository contains my personal notes from the **App Deployment Skill Sprint** course covering cloud computing, Linux, and DevOps fundamentals using AWS.

The goal of the week was to manually deploy a Node.js application with a MongoDB database on AWS EC2, iterating from a manual deployment all the way to automated image-based deployments with monitoring and auto-scaling.

---

## Notes by Day

| Date   | Topics                                                                                                     |
| ------ | ---------------------------------------------------------------------------------------------------------- |
| 09 Mar | Cloud concepts, IaaS/PaaS/SaaS, AWS setup, SSH key pairs, EC2 launch, security groups, Git Bash            |
| 10 Mar | Linux commands, sudo/apt, NGINX, systemctl, bash scripting, SCP, Node.js v20 install, app deployment       |
| 11 Mar | DevOps theory, CICD, Git version control, Markdown, deploy script, pm2, NGINX reverse proxy                |
| 12 Mar | GitHub, two-tier architecture, MongoDB install + config, environment variables, DB_HOST, /posts page       |
| 13 Mar | AMIs, launching from custom images, User Data, CloudWatch monitoring, SRE/SLA/SLO/SLI, ASG, load balancing |

---

## Key Topics Covered

### Cloud & AWS

- Cloud computing concepts — on-prem vs cloud, IaaS / PaaS / SaaS
- AWS EC2 — launching, connecting, terminating instances
- Security groups — configuring inbound rules (ports 22, 80, 3000, 27017)
- AMIs (Amazon Machine Images) — creating and launching from custom images
- CloudWatch — detailed monitoring, dashboards, alarms
- Auto-Scaling Groups and Application Load Balancers
- IAM and the principle of least privilege

### Linux

- Core commands (`ls`, `cd`, `pwd`, `whoami`, `uname`, `clear`)
- Package management (`sudo apt update`, `sudo apt upgrade`, `sudo apt install`)
- Service management (`sudo systemctl start|stop|restart|enable|status`)
- File editing with `nano`
- SSH connection via Git Bash

### DevOps & Scripting

- DevOps origins — breaking down the Dev/Ops wall
- The iteration mindset — get it working, improve it, document it
- CICD concepts — Continuous Integration, Continuous Delivery, Continuous Deployment
- Bash scripting — shebang, comments, the `-y` flag, `source script.sh`
- Python scripting (demonstration) — image conversion, web scraping, speed testing

### App Deployment

- Node.js v20 installation via NodeSource PPA
- `npm install` and `package.json`
- Running apps with `pm2` (background process manager)
- NGINX as a reverse proxy (port 80 → port 3000)
- Git clone for app code

### Database (MongoDB)

- NoSQL vs SQL — when to use each
- MongoDB 7 installation (including GPG key setup)
- Configuring `bindIp: 0.0.0.0` in `/etc/mongod.conf`
- Starting and enabling `mongod` as a system service
- Environment variables — `export DB_HOST=mongodb://<ip>:27017/posts`
- Database seeding with `node seeds/seed.js`
- Two-tier deployment — separating app and database instances

### Git & GitHub

- `git init`, `git status`, `git add`, `git commit`, `git push`
- `git config --global user.name / user.email`
- Connecting a local repo to GitHub (`git remote add origin`)
- Markdown documentation in `.md` files

---
