## Monitoring with CloudWatch

### Why monitor?

Without monitoring:

- If CPU hits 100%, the app silently breaks.
- You only find out when someone tells you the site is down.
- You have to investigate from scratch to find the cause.

With monitoring: you have **visibility** — you can see what your instances are doing in real time.

### Site Reliability Engineering (SRE)

**SRE (Site Reliability Engineer)** is a specialised role focused entirely on post-deployment reliability. Key concepts to know:

| Acronym | Full name               | Meaning                                                                                                                                              |
| ------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **SLA** | Service Level Agreement | The minimum service level _promised to the customer_. If you drop below this, you owe compensation. (e.g. 99% uptime)                                |
| **SLO** | Service Level Objective | Your _internal target_, set higher than the SLA to give wiggle room. (e.g. 99.5% uptime — if you fail to hit this, you might still be above the SLA) |
| **SLI** | Service Level Indicator | The _metrics_ you measure to track progress toward the SLO. (e.g. CPU utilisation, page load time, error rate)                                       |

> **Analogy:** SLA = the promise you make to customers. SLO = what you actually aim for internally (higher, so you have a buffer). SLI = the instruments you use to measure whether you're hitting the SLO.

### Monitoring progression (from worst to best)

| Level                            | What                                              | Analogy                                         |
| -------------------------------- | ------------------------------------------------- | ----------------------------------------------- |
| No monitoring                    | Problems are invisible                            | Nothing                                         |
| Dashboard                        | You can see metrics — but only if you're watching | Smoke detector that needs someone to look at it |
| Dashboard + Alarm + Notification | AWS emails you when a threshold is breached       | Smoke detector with an alarm                    |
| Auto-scaling                     | AWS automatically responds to problems            | Smoke detector + sprinkler system               |

### Setting Up CloudWatch Monitoring

1. EC2 → Instance Summary → scroll down to the **Monitoring** tab
2. Click **"Manage Detailed Monitoring"** → Enable → Confirm
   - Detailed monitoring costs slightly more but gives finer-grained metrics
3. On the monitoring tab, click the **three dots** next to any metric → **"Add to Dashboard"**
4. Click **"Create New"** → name it `SE-yourname-first-dashboard`
5. Click the grey **Create** button first (to create the dashboard), then click the orange **Add to Dashboard** button
6. Your CloudWatch dashboard opens with line chart widgets

### Customising your dashboard

- **Resize widgets** by dragging the bottom-right corner
- **Delete widgets** you don't want (three dots → Delete)
- **Change time range** with the blue calendar button (e.g. last 15 minutes)
- **Save manually** using the orange Save button — autosave is off by default, which is recommended (you can undo changes before saving)

---
