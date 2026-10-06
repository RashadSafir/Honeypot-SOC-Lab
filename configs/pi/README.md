# Pi Host Firewall (ufw)

The Wazuh installer binds the agent ports (1514/1515), the API (55000) and the dashboard (443) to every interface, so they were reachable from anything on my home Wi-Fi. Instead of re-binding each service to the Tailscale IP, I used one firewall rule based on the interface, so only traffic coming in over Tailscale is allowed.

## Rules

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0
sudo ufw allow from [HOME-LAN-SUBNET] to any port 22 proto tcp
sudo ufw enable
```

| Rule | Purpose |
|---|---|
| Deny incoming by default | Nothing reaches the Pi unless a rule allows it |
| Allow in on `tailscale0` | Wazuh, SSH and the dashboard over Tailscale (covers IPv6 too) |
| SSH from the home LAN | Fallback in case Tailscale breaks |

Tailscale's grants still decide which tailnet devices reach which ports (the VM only gets 1514/1515). `ufw` just makes sure nothing outside the tailnet gets in at all.

The indexer (9200) only listens on localhost, so it was never exposed.

You could bind each service to the Tailscale IP, but:
- One rule covers all 4 ports & IPv6, instead of editing four configs.
- Tailscale can come up after Wazuh at boot, so binding to its IP could fail

## Verified
From the VM, Pi port 1514 succeeds and SSH times out. See [`wazuh-pi-ports.txt`](../../assets/wazuh-pi-ports.txt) and [`wazuh-port-tests.txt`](../../assets/wazuh-port-tests.txt). (Note: Still need to do a LAN-side check).

