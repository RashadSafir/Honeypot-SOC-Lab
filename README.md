# Honeypot SOC Lab
(Will polish later, just a super basic description atm)

A home lab where I run a Cowrie honeypot on Azure, ship its logs to a Wazuh
SIEM on a Raspberry Pi, and write threat reports on what attackers have done.

## Current Status

Cowrie logs now ship from the VM to Wazuh on the Pi over Tailscale (The first bot sessions showed up on the Pi within seconds). Wazuh is only reachable over Tailscale, and the VM can only talk to its two agent ports. The next goal is to set up index retention so the Pi's SD card doesn't fill up, then writing my first detection rules for the Cowrie events. 

## Progress

- [x] Planning, Azure budget alerts, Pi 5 setup
- [x] Azure network/VM, admin access over Tailscale only
- [x] Cowrie deployed, exposed on 22/23, verified with external scans
- [X] Wazuh SIEM installed on the Pi
- [X] Ship logs to the Pi over Tailscale (tailnet is segmented)
- [ ] Custom Cowrie decoders
- [ ] IP enrichment (AbuseIPDB / VirusTotal)
- [ ] Map detection rules to frameworks (like MITRE ATT&CK)
- [ ] Threat reports

## Current Layout

- `configs/` – settings I changed on the VM, the Pi, and in Azure
- `detections/` – Wazuh decoders and rules
- `scripts/` – enrichment and helper scripts
- `reports/` – threat reports
- `assets/` – evidence & screenshots
- `template/` - blank threat report template (to be used for when I actually document reports)

(architecture/design choices later)