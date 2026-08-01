Usually **not recommended** to expose a Proxmox web GUI to the public internet—even via Cloudflare Tunnel—unless you implement strong compensating controls. It’s safer to keep it **only reachable via a VPN** or **private network**, and use tunneling only for narrow, tightly controlled access.

### Why “public via tunnel” is risky

- **Expanded attack surface:** Even if it’s not “directly exposed,” it’s still reachable from the internet, so any weakness in authentication, session handling, or the Proxmox stack becomes reachable.
- **Account/session risk:** If a password is reused, phished, or weak, tunnel access makes it immediately exploitable.
- **Operational risk:** Misconfiguration (bypassing browser security checks, allowing broad access, weakening auth) is common with tunnels.

### When it can be acceptable

If you do it, aim for **minimum exposure**:

- **Require SSO / identity checks** (Cloudflare Access) instead of just basic auth.
- **Restrict who can reach it** (only specific identities/emails, device posture if you use it, IP/location restrictions if appropriate).
- **Use MFA everywhere** and ensure Proxmox auth is configured securely.
- **Harden Proxmox**: disable unused services, keep Proxmox updated, and lock down permissions/roles.
- **Limit tunnel scope**: only proxy the Proxmox GUI port(s) you truly need; avoid exposing extra endpoints.
- **Enable HTTPS end-to-end** and consider additional security headers / secure cookie settings as applicable.
- **Monitor and alert** on login attempts and unusual access patterns.

### Preferred alternative

- **VPN into your network** (WireGuard/OpenVPN) and then access Proxmox only from inside the VPN.
- Or **Cloudflare Access + tunnel**, but with strict identity-based allowlists and MFA (not open access, not “password-only for everyone”).

### Quick rule of thumb

- If you can say “only my accounts can get in, with MFA and identity-based controls,” tunneling is _more_ defensible.
- If it would be “anyone with the link/password,” it’s not a good idea.

If you tell me how you plan to use Cloudflare Tunnel (Cloudflare Access on/off, whether you’d allow specific users/IPs, and what auth method Proxmox will use), I can recommend a safer configuration approach.
