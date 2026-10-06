# Raspberry Pi (Wazuh SIEM)

Settings I changed on the Pi. It runs Ubuntu Server 24.04 and Wazuh 4.14 all-in-one, on a 128 GB microSD card.

## journald cap (`size.conf`)

Caps the system journal at 100 MB so logs can't fill or wear out the SD card. Goes in `/etc/systemd/journald.conf.d/`.

## Host firewall (ufw)

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
From the VM, Pi port 1514 succeeds and SSH times out. From the home LAN (Tailscale off), SSH succeeds and 443, 1514, 1515, and 55000 all time out. See [`wazuh-pi-ports.txt`](../../assets/wazuh-pi-ports.txt), [`wazuh-port-tests.txt`](../../assets/wazuh-port-tests.txt), and [`wazuh-lan-tests.txt`](../../assets/wazuh-lan-tests.txt).

## Index retention (`ism-retention-policy.json`)

Without a retention policy, Wazuh keeps every daily alert index forever, which would eventually fill the SD card and wear it down. This policy deletes `wazuh-alerts-*` indices once they're 30 days old. The threat reports and evidence would be the long-term record, so the indexer does not need to stay longer than 30 days.
- New daily indices get the policy automatically (`ism_template`).
- Indices that existed before the policy had to be attached by hand (in Index Management -> Indicies -> Apply policy).
- 30 days is a starting point. The alert volume will go up once I set up the Cowrie rules, so I'll have to just accordingly after that.