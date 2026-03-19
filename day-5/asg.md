## Auto-Scaling Groups (ASG) and Load Balancing

### The problem this solves

Our current deployment is a single instance. If it goes down, the site is down. Even with monitoring and alarms, someone still has to manually spin up a replacement. Auto-scaling removes that human dependency.

### Scaling types

| Type                   | Also called     | How it works                                     | Preferred for                                     |
| ---------------------- | --------------- | ------------------------------------------------ | ------------------------------------------------- |
| **Horizontal scaling** | Scaling out/in  | Make _more instances_ of the same size           | Most web workloads — better stability             |
| **Vertical scaling**   | Scaling up/down | Make the single instance _bigger_ (more CPU/RAM) | Data-heavy workloads needing raw processing power |

Horizontal scaling is almost always preferred. If one instance in a group of three goes down, two still serve traffic.

### Availability Zones (AZs)

The Ireland region (EU-West-1) has **three availability zones**: `eu-west-1a`, `eu-west-1b`, `eu-west-1c`. These are separate physical data centres close together and connected. By spreading instances across all three AZs, even if one data centre has a problem, your other instances continue serving traffic.

### Components needed for an ASG

```
Custom App AMI
      ↓
User Data Script (npm install + pm2 start)
      ↓
Launch Template (saved EC2 config: AMI + instance type + key pair + SG + User Data)
      ↓
Auto-Scaling Group (uses the launch template + policy: min/desired/max)
      ↓
Load Balancer (sits in front — distributes traffic across instances)
```

### Launch Template

A **Launch Template** is a saved version of the EC2 launch form. Instead of filling in AMI, instance type, key pair, security group, and User Data every time, you save these settings once and reuse them.

1. EC2 → Launch Templates → **Create Launch Template**
2. Name: `SE-yourname-app-LT`
3. AMI: your custom app AMI
4. Instance type: T3 Micro
5. Key pair: your usual key pair
6. Security group: your app security group (ports 22, 80, 3000)
7. Advanced Details → User Data: paste your startup script
8. **Test it first** — Launch Instance from Template before creating the ASG

### Creating the Auto-Scaling Group

1. EC2 → Auto Scaling Groups → **Create**
2. Name: `SE-yourname-Sparta-ASG`
3. Launch template: select the one you just created
4. Click Next → Availability Zones: select all three (`1a`, `1b`, `1c`)
5. **Attach a new Load Balancer:**
   - Type: **Application Load Balancer** (HTTP/HTTPS traffic)
   - Name: `SE-yourname-Sparta-ASG-LB`
   - Scheme: **Internet-facing** (traffic from the internet)
   - Listener: port 80
   - Target group: create a new one (name it with `-TG` suffix)
   - Enable health checks
6. **Group size:** Desired: **2**, Minimum: **2**, Maximum: **3**
7. **Scaling policy:** Scale out when CPU > 50% for 1 minute
8. Review and create

### How it works

- The ASG maintains at least 2 instances at all times (minimum = 2).
- If one instance goes down or becomes unhealthy, AWS automatically launches a replacement.
- If CPU exceeds 50%, AWS scales out to 3 instances.
- Users go to the **Load Balancer DNS name** (not a specific instance IP). The load balancer distributes traffic evenly across healthy instances.

### Testing auto-scaling

From the ASG's Instance Management tab, manually terminate one instance. The ASG detects it has dropped below the minimum (2) and automatically provisions a new one. You can watch this happen in real time — the new instance appears as "pending", then "running".

### Deleting an ASG — IMPORTANT, DO IN THIS ORDER

If you leave an ASG running, it will keep spawning instances and incur costs.

1. **Delete the Load Balancer first:** EC2 → Load Balancers → Actions → Delete → type "confirm"
2. **Delete the Target Group:** EC2 → Target Groups → Actions → Delete
3. **Delete the Auto-Scaling Group:** EC2 → Auto Scaling Groups → Actions → Delete → type "delete"

Deleting the ASG automatically terminates all instances it manages.

---

## Key Commands — Full Week Reference

```bash
# ─── Instance Setup ───────────────────────────────────────────────────────────
sudo apt update -y && sudo apt upgrade -y

# ─── NGINX ────────────────────────────────────────────────────────────────────
sudo apt install nginx -y
sudo systemctl status|start|stop|restart|enable nginx

# ─── NGINX Reverse Proxy config ──────────────────────────────────────────────
sudo nano /etc/nginx/sites-available/default
# Edit the location / block — see Day 5 notes for full config
sudo systemctl restart nginx

# ─── Node.js v20 ──────────────────────────────────────────────────────────────
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
node -v

# ─── App ──────────────────────────────────────────────────────────────────────
git clone <url>
cd SE-sparta-test-app/app
sudo npm install
pm2 start app.js
pm2 kill

# ─── MongoDB ──────────────────────────────────────────────────────────────────
# (GPG key + repo setup — see Day 4 notes for full commands)
sudo apt install -y mongodb-org
sudo nano /etc/mongod.conf              # change bindIp: 127.0.0.1 → 0.0.0.0
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

# ─── Two-Tier Connection ──────────────────────────────────────────────────────
export DB_HOST=mongodb://<DB-IP>:27017/posts
printenv DB_HOST
node seeds/seed.js                      # seeds DB and confirms connection

# ─── User Data (in Advanced Details on EC2 Launch) ───────────────────────────
#!/bin/bash
sleep 10
cd /home/ubuntu/SE-sparta-test-app/app
npm install
pm2 start app.js

# ─── Git ──────────────────────────────────────────────────────────────────────
git init
git status
git add .
git commit -m "message"
git push origin main
git remote add origin <url>
git config --global user.name "Name"
git config --global user.email email@example.com

# ─── Bash Basics ──────────────────────────────────────────────────────────────
whoami / pwd / ls / cd / clear
source script.sh
sleep 10
```
