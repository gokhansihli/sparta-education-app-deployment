## GitHub — Pushing Local Work to the Cloud

### Git (local) vs GitHub (cloud repository)

|             | Git                                      | GitHub                                       |
| ----------- | ---------------------------------------- | -------------------------------------------- |
| **What**    | Version control software on your machine | Cloud-hosted service for storing Git repos   |
| **Lives**   | On your local computer                   | On the internet (github.com)                 |
| **Purpose** | Track changes locally                    | Backup, collaboration, visibility, portfolio |

### Linking and Pushing

```bash
# Link your local repo to a GitHub remote (do this once)
git remote add origin <GitHub-repo-HTTPS-URL>

# Push your commits to GitHub
git push origin main
```

### Why GitHub matters

- **Backup** — your work is safe even if your laptop dies.
- **Portfolio** — employers can browse your public repos. A well-structured GitHub profile is a powerful job application tool.
- **Collaboration** — multiple people can work on the same codebase.
- **Visibility** — the whole team can see what everyone is working on.

> **Recommendation:** Push after every commit. Get into the habit. From today, every time you `git commit`, also `git push`.

### GitHub and CICD

GitHub enables CICD workflows. When multiple developers are working on the same codebase, they each work on their own branch. The CICD pipeline automates testing and merging those branches into main — which is why you see daily game patches and live website updates rather than rare, huge releases.

---

## Two-Tier Deployment — Theory

### Why separate the app and the database?

So far, we have been running everything on a single instance (the "monolith" approach). This is simple but fragile.

**Monolith:**

- Simple — easy to set up and manage
- If the app crashes, the database crashes too (and vice versa)
- Security risk — if someone accesses the app server, they're on the same machine as the database
- Can't scale the app independently of the database

**N-tier (e.g. 2-tier):**

- The app runs on one instance, the database runs on a separate instance
- If one instance goes down, the other is unaffected
- Multiple app instances can connect to the same single database
- Security — the database doesn't need to be publicly exposed beyond its specific port
- Each tier can be scaled independently

> Analogy: it's the same logic as why we split up data centres into availability zones — don't put all your eggs in one basket.

**Architecture we're building:**

```
[User / Browser]
       ↓ HTTP (port 80)
[App Instance — NGINX + Node.js]
       ↓ MongoDB connection (port 27017)
[Database Instance — MongoDB]
```

### Microservices (for context)

Even further than 2-tier, you can break an app into many tiny services (microservices), each on its own instance. More robust — if one microservice goes down, the others keep running. But also more complex to manage.

---
