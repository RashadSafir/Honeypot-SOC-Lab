# Evidence

Raw command output that was captured during the build. The files are unedited
except for when I redacted things, like the internal addresses (replaced with
placeholders)

## Cowrie Deployment

| File | What it shows |
|---|---|
| `cowrie-service-evidence.txt` | Before the iptables redirect: Cowrie running under systemd as the unprivileged `cowrie` user, listening on 2222/2223; real sshd bound only to the Tailscale IP on 22222. After: NAT rules redirecting public 22/23 to Cowrie, scoped to `eth0`. |
| `nmap-targeted.txt` | External scan of the public IP: 22 and 23 open; Cowrie's real ports (2222/2223) and admin SSH (22222) filtered by the NSG. |
| `nmap-full.txt` | Full 65,535-port external scan: only 22 and 23 reachable. |


## Screenshots

### Sandbox Verification

![Real VM vs. Cowrie session](images/sandbox-fake-vs-real.png)

**Left**: This represents the real VM, running Ubuntu 24.04 on an Azure kernel.

**Right**: This represents an SSH session into Cowrie on the same machine. The attacker would see
a fake Debian 12 host with its own hostname and kernel string (not the real system ofc). This 
confirms Cowrie is running in emulated-shell mode with no access to the real OS. 

### NSG Inbound Rules

![NSG Inbound Rules](images/InboundSecurityRules.png)

Only TCP 22 (SSH) and TCP 23 (Telnet) are allowed in from the internet, and the host redirects both to
Cowrie. Every other inbound connection goes through Azure's default 'DenyAllInbound' rule. The real 
admin SSH (port 22222) has no allow rule, making it only reachable over Tailscale. (Also good to mention
that Azure flagged port 22 because we shouldn't normally expose SSH. In this case though, that's the
honeypot.)

### NSG Outbound Rules

![NSG Outbound Rules](images/OutboundSecurityRules.png)

'Deny-SMTP-Out' blocks outbound TCP 25, so even if something on the VM did end up getting compromised,
it couldn't be used to send spam, which Microsoft's AUP prohibits. Other outbound internet traffic
stays allowed since the VM needs it for updates/Tailscale/Wazuh (once that is implemented).
