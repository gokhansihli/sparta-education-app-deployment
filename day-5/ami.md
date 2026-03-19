## AMIs — Amazon Machine Images

### What is an AMI?

An **AMI (Amazon Machine Image)** is a **template/checkpoint** of an EC2 instance's state. It captures:

- The operating system
- All installed software and their versions
- Any configuration changes you've made
- Any files or folders present

> **Analogy:** A video game save file. You don't have to start from level 1 every time — you save your progress and continue from exactly where you were. The base Ubuntu AMI is like starting a new game; your custom AMI is your 25-hour save file.

### Why make custom AMIs?

- **Time saving** — no need to re-run your entire deploy script on every new instance
- **Standardisation** — everyone on the team uses the same image with the same software versions
- **Automation** — for the database, once everything is configured and enabled, new instances need **zero manual input** after launch
- **CICD prerequisite** — custom AMIs + launch templates enable auto-scaling groups

### The database is particularly good for imaging

Once MongoDB is installed, configured (`bindIp: 0.0.0.0`), and enabled as a startup process, the image is completely self-sufficient. Spin up a new instance from this image → MongoDB starts automatically → connect your app → done. No SSH login required.

---

## Creating a Custom AMI (Database Instance)

### Prerequisites — run these BEFORE creating the image

Ensure all three of the following are true on your MongoDB instance:

1. MongoDB 7 is installed
2. `bindIp` is set to `0.0.0.0` in `/etc/mongod.conf`
3. MongoDB is enabled as a startup process:

```bash
sudo systemctl enable mongod
```

The `enable` command is **critical**. Without it, MongoDB won't start automatically when the OS boots. Your image would have MongoDB installed and configured, but you'd still need to log in and run `sudo systemctl start mongod` every time — defeating the purpose.

### Step-by-step: Creating the AMI

1. **Stop the instance** (graceful shutdown ensures data consistency):
   - EC2 → Instance Summary → Instance State → **Stop**
   - Wait for the instance state to show **"stopped"**
   - Once stopped, your SSH session will be disconnected — this is expected

2. **Create the image:**
   - Actions → Image and Templates → **Create Image**
   - **Image name:** `SE-yourname-MongoDB7-AMI`
   - **Description:** `MongoDB7 configured and ready to be connected`
   - Leave "Reboot instance" toggled **ON** (ensures data consistency)
   - Leave storage defaults (8GiB, delete on termination enabled)
   - Click **Create Image**

3. **Wait ~5 minutes** for the image to be created. Check status:
   - EC2 → AMIs → filter "Owned by me"
   - Status will change from "pending" to **"available"**

> **Do not terminate the original stopped instance yet.** Only terminate it once you have tested the new AMI and confirmed it works. If the image has a problem, you'll need to go back to the original.

---

## Launching from a Custom AMI

### Step 1: Launch a new instance from your image

1. EC2 → Instances → **Launch Instances**
2. In the AMI section, click the **"My AMIs"** tab (not Quick Start)
3. Search for your AMI name and select it — wait patiently, this section is slow
4. Instance type: **T3 Micro**
5. Key pair: your usual key pair (shouldn't need to log in, but keep it for troubleshooting)
6. Security group: select your MongoDB security group (ports 22 and 27017)
7. Launch

### Step 2: Test the image (no login needed)

Go to your **app instance** and update the `DB_HOST` environment variable to point to the new DB instance's public IP:

```bash
# Kill the running app first
pm2 kill

# Update DB_HOST with the new instance's IP (use arrow keys to recall previous command)
export DB_HOST=mongodb://<NEW-DB-PUBLIC-IP>:27017/posts

# Verify
printenv DB_HOST

# Navigate to app folder
cd SE-sparta-test-app/app

# Install dependencies (safe to re-run)
sudo npm install

# Seed the database — this is the connection test
node seeds/seed.js
```

Expected output:

```
connected to database
database cleared
database seeded with 100 records
database connection closed
```

If this works, your AMI is functioning correctly. The new database instance is running MongoDB, ready to receive connections — all without you ever logging into it.

```bash
# Start the app
pm2 start app.js
```

Visit `http://<app-public-ip>/posts` — should show blog posts.

### Step 3: Terminate the original stopped instance

Once the AMI test passes, the original stopped instance is redundant:

EC2 → select stopped instance → Instance State → **Terminate**

---

## NGINX Reverse Proxy (Detail)

Currently users access the app at `<ip>:3000`. With a reverse proxy, NGINX listens on port 80 and forwards requests internally to port 3000 — so users just visit `<ip>` with no port number.

### Configuring the reverse proxy

On the **app instance**:

```bash
sudo nano /etc/nginx/sites-available/default
```

Find the `location /` block. Replace its contents with:

```nginx
location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}
```

Save (`Ctrl+X`, `Y`, `Enter`), then restart NGINX:

```bash
sudo systemctl restart nginx
```

Now `http://<public-ip>` (port 80) serves the app directly. No `:3000` required. This is much more user-friendly and is how real production deployments work.

---

## User Data — Running Scripts on Boot

**User Data** is a bash script that AWS runs **automatically as the instance starts**, before you ever log in. It runs as the **root user**.

You enter it in the Launch Instance form: **Advanced Details → User Data** (at the very bottom of the page).

### Why use User Data?

The database AMI needs no User Data — it starts automatically via `systemctl enable`. But the app needs to run a few commands after boot (npm install, seed, pm2 start). User Data automates this so the app instance also needs no manual login.

### Example User Data script for the app

```bash
#!/bin/bash

# Wait 10 seconds for the file system to be ready
# (user data runs so fast the filesystem may not be mounted yet)
sleep 10

# Navigate to app folder (user data runs as root, so specify full path)
cd /home/ubuntu/SE-sparta-test-app/app

# Install dependencies
npm install

# Start the app in the background
pm2 start app.js
```

### Important notes

- **Start with `sleep 10`** — User Data runs so fast that the file system sometimes isn't ready. Without the sleep, `cd` will fail because the folder doesn't exist yet.
- **Use full paths** — User Data runs as root (not as `ubuntu`), so `cd` starts from `/`, not `/home/ubuntu`. Always write the full path.
- User Data is hard to debug — if something goes wrong, you won't see the error output easily. Put as much as possible into the AMI and keep User Data minimal.
- This is combined with a custom **app AMI** (Node.js, NGINX, app code all pre-installed) → new instances deploy the app automatically with no login.

---
