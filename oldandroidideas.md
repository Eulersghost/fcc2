Here are some creative and practical ideas for repurposing an air-gapped Google Pixel in a homelab environment:

---

## 🔐 Security & Cryptography

- **Hardware key / FIDO2 authenticator** — Use apps like FIDO2/NFC tools to turn the Pixel into a second-factor device for logging into homelab services (Proxmox, routers, etc.).
- **Air-gapped signing / GPG key storage** — Keep your PGP/GPG private keys on the Pixel, never connected to any network. Sign artifacts or emails on the phone, then transfer via QR codes or USB.
- **Authenticator app hub** — Install Aegis, FreeOTP, or andOTP and use it as a dedicated, offline 2FA device for all your homelab accounts. Much more secure than keeping TOTP on your daily phone.
- **Shamir's Secret Sharing participant** — Use the phone as one "share holder" in a split-key scheme (e.g., for recovering a master password or seed phrase).

---

## 🧪 Testing & Development

- **Android app testing device** — Deploy APKs over USB to test your own apps or sideloaded tools without risking your main device. Great for beta testing or running apps that need an isolated environment.
- **Malware analysis sandbox** — Intentionally install suspicious APKs in a fully isolated environment to observe behavior without network risk (though you'd want a burner device for truly malicious stuff).
- **Local-only PWA / web app host** — Host a lightweight local web server (e.g., via Termux) and test Progressive Web Apps offline.

---

## 📡 Sensors & Monitoring

- **Environmental sensor hub** — Connect USB OTG sensors (temperature, humidity, CO₂) and log data locally. Display on a dashboard or sync later via USB.
- **Camera / surveillance node** — Use apps like IP Webcam or Alfred Camera. Even air-gapped, you can record to local storage and periodically pull footage via USB.
- **USB host for SDR (Software Defined Radio)** — Plug in an RTL-SDR dongle via OTG and use SDR Touch to scan/record local RF signals offline.
- **Dashcam / timelapse rig** — Mount it somewhere and run a timelapse or monitoring camera that saves to local storage.

---

## 🧊 Cold Storage & Backup

- **Cryptocurrency seed phrase vault** — Store your wallet seed phrases (e.g., for Bitcoin cold storage) in an encrypted vault app like SeedVault or Encrypted Notes. Never connects to the internet = no remote attack surface.
- **Offline password vault** — Use KeePassDX (KeePass Android client) with your `.kdbx` database. Transfer updates via USB or QR code sync.
- **Encrypted backup of critical documents** — Store encrypted copies of important homelab configs, certificates, and documentation. Think of it as a "digital safe deposit box."
- **2FA recovery codes vault** — A dedicated, offline store for all your backup/recovery codes.

---

## 🛠 Utility & Infrastructure

- **Serial console terminal** — Use a USB-OTG-to-serial adapter with apps like Serial USB Terminal to console into switches, routers, PDU, or servers (Cisco, MikroTik, etc.) — a portable out-of-band management device.
- **Termux powerhouse** — Install Termux and you essentially have a pocket Linux box. Run Python scripts, SSH client (for USB-tethered sessions), local git repos, cron jobs, etc. — all offline.
- **Dashcam for network rack** — Point it at your homelab rack to record blinkenlights for debugging intermittent issues ("what was the LED doing when the crash happened?").
- **Portable documentation reader** — Load homelab runbooks, network diagrams, and SOPs onto the device for quick reference during outages when your main screens are down.

---

## 🎯 Fun / Niche

- **e-ink style dashboard** — Use an app like Info Dashboard to display a static homelab status board (you'd update it manually or via USB).
- **Retro gaming console** — Install RetroArch and load ROMs for a dedicated offline emulation station.
- **Music player / media server** — Load it with FLAC files and use it as a high-quality offline media player connected to your amp/speakers via the headphone jack (if it's an older Pixel with one) or USB-C DAC.
- **DIY hardware keystroke injector** — With the right cable/apps, some use rooted Android devices as USB HID devices for authorized pentesting of your own homelab machines.

---

### Quick Recommendation Matrix

| Your Priority | Best Pick |
|---|---|
| **Max security** | GPG key storage + KeePassDX vault |
| **Most useful daily** | 2FA authenticator hub (Aegis) |
| **Most fun** | RetroArch gaming + SDR scanning |
| **Best homelab tool** | Serial console terminal via OTG |
| **Best backup role** | Encrypted cold-storage document vault |

The beauty of an air-gapped device is that it eliminates the entire class of network-based attacks. For anything involving secrets, keys, or critical data, that's a genuinely strong security posture — not just a novelty. Would you like me to go deeper on any of these (e.g., specific app recommendations or setup steps)?