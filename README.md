# Honeypot SOC Lab
(Will polish later, just a super basic description atm)

A home lab where I run a Cowrie honeypot on Azure, ship its logs to a Wazuh
SIEM on a Raspberry Pi, and write threat reports on what attackers have done.

## Current Status

The Azure infrastructure and the Pi are set up, and admin access runs entirely
over Tailscale. The honeypot isn't live yet; Cowrie is next.

## Current Layout

- `configs/` – settings I changed on the VM, the Pi, and in Azure
- `detections/` – Wazuh decoders and rules
- `scripts/` – enrichment and helper scripts
- `reports/` – threat reports
- `assets/` – screenshots and diagrams
- `template/` - blank threat report template (to be used for when I actually document reports)

(architecture/design choices later)