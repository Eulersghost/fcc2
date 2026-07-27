Now I have a solid understanding. Let me compile this into a clear, beginner-friendly explanation.

---

# Proxmox Firewall Rules: A Strategy Guide for New Network Engineers

## The Mental Model — Three Layers

Think of the Proxmox firewall like a building with three security checkpoints stacked on top of each other. Understanding how they interact is *the* foundational concept:

| Level | What It Protects | Scope |
|---|---|---|
| **Datacenter** | All host nodes in the cluster | Cluster-wide baseline rules |
| **Node (Host)** | A single physical Proxmox server | That node only |
| **VM / Container** | Individual guest machines | That specific guest only |

**Key things that trip up newcomers:**

- The Datacenter firewall is a **global on/off switch**. If it's off, nothing below it works [^6].
- Datacenter rules **cascade down to nodes** but **NOT down to VMs/containers**. This is the #1 surprise [^2][^7].
- Node rules **override** Datacenter rules, and VM rules **override** both — a VM is essentially its own isolated entity [^5].
- When enabled, the firewall **blocks everything by default** except a built-in set of exceptions [^1].

---

## The Best Strategy: "Default Deny + Explicit Allow," Bottom-Up

The single most recommended approach is a **default-deny posture with explicit allow rules**, built from the inside out. Here's the step-by-step strategy:

### Step 1 — Build Your "Management" IP Set FIRST (Before Enabling Anything)

Before you even think about turning on the firewall, create an **IP Set** called `management` containing all the admin IPs/subnets you'll connect from [^1].

> **Why?** IP Sets let you reference a group of IPs by name (`+management`) in any rule. When your office IP changes, you update the set once — not fifty rules.

Go to **Datacenter → Firewall → IPSet → Add**, name it `management`, and add your trusted IPs/CIDRs.

### Step 2 — Open an SSH Session and Keep It Running

> "Please open a SSH connection to one of your Proxmox VE hosts before enabling the firewall. That way you still have access to the host if something goes wrong." — Proxmox official docs [^1]

This is your **safety net**. If you misconfigure the firewall and lock yourself out of the web GUI, that SSH session stays alive (established connections are preserved) and you can fix it from the command line.

### Step 3 — Define Baseline Allow Rules at the Datacenter Level

At **Datacenter → Firewall → Add**, create your cluster-wide access rules. These apply to every node's host zone [^2]:

| Direction | Protocol | Dest Port | Source | Purpose |
|---|---|---|---|---|
| IN | TCP | 8006 | +management | Web GUI |
| IN | TCP | 22 | +management | SSH |
| IN | TCP | 3128 | +management | SPICE proxy |
| IN | TCP | 5900:5999 | +management | VNC web console |
| IN | TCP | 60000:60050 | +management | Live migration |
| IN | UDP | 5405:5412 | cluster net | Corosync (cluster only) |

Proxmox actually has **built-in default exceptions** for many of these, but explicitly creating them (especially restricted to your management IP set) is strongly recommended — it tightens the default which allows them from broader sources [^1][^2].

### Step 4 — Enable the Firewall (Datacenter Level First)

Now flip the switch at **Datacenter → Firewall → Options → Firewall: Yes**.

Remember: the moment you do this, everything not explicitly allowed gets dropped. That's why Steps 1–3 matter [^2].

### Step 5 — Use Security Groups for VM Patterns

**Security groups** are reusable rule bundles defined at the cluster level [^1]. Instead of recreating the same rules on every VM, define a group once:

```
# /etc/pve/firewall/cluster.fw
[group webserver]
IN  ACCEPT -p tcp -dport 80
IN  ACCEPT -p tcp -dport 443
```

Then apply it to any VM:

```
# /etc/pve/firewall/<VMID>.fw
[RULES]
GROUP webserver
```

This is how you **scale** your firewall strategy — define patterns once, apply everywhere.

### Step 6 — Configure Each VM/Container Individually

Since VMs **do not inherit** node or datacenter rules, you must enable and configure the firewall per guest [^2]:

1. Select the VM → **Firewall → Options → Firewall: Yes**
2. Add only the ports that service needs (apply a security group if one fits)
3. Leave the default input policy as DROP

---

## Leverage Proxmox's Built-in Helpers

Proxmox gives you three features that make rule management far easier — use them [^8]:

| Feature | What It Does | When to Use |
|---|---|---|
| **Macros** | Predefined rule sets for common services (e.g., `HTTP(ACCEPT)`) | Instead of manually specifying protocol + port every time |
| **IP Sets** | Named groups of IPs/CIDRs referenced as `+name` | For management IPs, trusted subnets, blocklists |
| **Security Groups** | Named collections of rules applied to multiple VMs | For VM "roles" (webserver, database, etc.) |

Example using a macro + IP set together:

```
IN HTTP(ACCEPT) -source +management
```

This single line allows HTTP only from IPs in your management set.

---

## The Strategy in a Nutshell

```
┌─────────────────────────────────────────────┐
│  DATACENTER LEVEL                           │
│  • Enable firewall (global switch)          │
│  • Create IPSet "management"                │
│  • Baseline rules: 8006, 22, 3128, etc.     │
│  • Define Security Groups (webserver, db…)  │
│  • Input policy: DROP (default)             │
└──────────────────┬──────────────────────────┘
                   │ cascades to nodes (NOT VMs)
┌──────────────────▼──────────────────────────┐
│  NODE LEVEL                                 │
│  • Node-specific overrides if needed        │
│  • Different nodes can have different rules │
│  • Input policy: DROP (default)             │
└──────────────────┬──────────────────────────┘
                   │ does NOT cascade to VMs
┌──────────────────▼──────────────────────────┐
│  VM / CONTAINER LEVEL                       │
│  • Enable firewall per VM                   │
│  • Apply Security Group for its role        │
│  • Add VM-specific exceptions only          │
│  • Input policy: DROP (default)             │
└─────────────────────────────────────────────┘
```

## Golden Rules to Remember

1. **Default deny, explicit allow** — Leave input policy as DROP. Only open what you need.
2. **Never enable the firewall without an active SSH session** as a backup [^1].
3. **Build rules before enabling** — Create your management access rules first, then flip the switch.
4. **Use IP Sets and Security Groups** — They keep your config DRY and maintainable.
5. **VMs don't inherit** — Every guest needs its own firewall enabled and configured.
6. **Restrict by source** — Don't just open port 8006 to the world; limit it to `+management`.
7. **Test changes carefully** — The Proxmox docs recommend testing in staging and backing up firewall configs regularly [^3].
8. **Rule order matters** — Place your most frequently matched rules first for performance [^3].

This "default-deny, layered, reusable" approach gives you defense in depth without relying on guest OS firewalls, and it scales cleanly as your Proxmox environment grows [^4].

**References**

[^1]: [Firewall - Proxmox VE](https://pve.proxmox.com/wiki/Firewall) (35%)
[^2]: [Quickly Configure the Firewall on Proxmox | WunderTech](https://www.wundertech.net/how-to-configure-the-firewall-on-proxmox/) (26%)
[^3]: [Proxmox Firewall Configuration | Bankai-Tech Docs](https://docs.bankai-tech.com/Proxmox/Docs/Networking/Firewall%20Configuration/) (11%)
[^4]: [Proxmox Firewall Rules: Complete Guide | ProxmoxR Blog](https://proxmoxr.com/blog/proxmox-firewall-guide) (9%)
[^5]: [Firewall rule order of precedence | Proxmox Support Forum](https://forum.proxmox.com/threads/firewall-rule-order-of-precedence.155128/) (6%)
[^6]: [PVE cluster firewall levels (cluster/node/vm-lxc) - Proxmox Support Forum](https://forum.proxmox.com/threads/pve-cluster-firewall-levels-cluster-node-vm-lxc.132317/) (5%)
[^7]: [differences between firewall level](https://forum.proxmox.com/threads/differences-between-firewall-level.24115/) (4%)
[^8]: [Proxmox VE Firewall](https://pve.proxmox.com/pve-docs/chapter-pve-firewall.html) (4%)