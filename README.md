# Honeypot SOC Lab
(Will polish later, just a super basic description atm)

A home lab where I run a Cowrie honeypot on Azure, ship its logs to a Wazuh
SIEM on a Raspberry Pi, and write threat reports on what attackers have done.

## Current Status

The honeypot went live. Cowrie is running on the Azure VM and catching SSH 
and Telnet traffic (the first scanner showed up within about five minutes). 
Logs stay on the VM for now; shipping them to Wazuh on the Pi is next.

## Progress

- [x] Planning, Azure budget alerts, Pi 5 setup
- [x] Azure network/VM, admin access over Tailscale only
- [x] Cowrie deployed, exposed on 22/23, verified with external scans
- [ ] Ship logs to the Pi over Tailscale (tailnet is segmented, need to install Wazuh next)
- [ ] Wazuh SIEM and custom Cowrie decoders
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