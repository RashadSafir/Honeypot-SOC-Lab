# NSG Rules (vm-honeypot-nsg)

This is the network security group attached to the honeypot VM's network
interface. Azure checks rules from lowest priority number
to highest, so my custom rules sit at 100 and run before Azure's defaults.

## Custom rules

| Name | Direction | Port | Protocol | Source | Destination | Action | Priority |
|---|---|---|---|---|---|---|---|
| Deny-SMTP-out | Outbound | 25 | TCP | Any | Any | Deny | 100 |
| Allow-Cowrie-SSH | Inbound | 22 | TCP | Any | Any | Allow | 110 |
| Allow-Cowrie-Telnet | Inbound | 23 | TCP | Any | Any | Allow | 120 |

I blocked outbound SMTP so that the VM can't send spam ever, 
if something were to go wrong with the honeypot.

Ports 22 and 23 are open to the internet (purpose of this project ofc).
On the VM, iptables redirects them to Cowrie on 2222/2223, since NSGs 
can't remap ports. Azure shows a warning next to SSH rule (documented
in [images](../../assets/images/)), since exposing SSH is normally
a risk.


## Rules I've removed

| Name | Direction | Port | Source |
|---|---|---|---|
| TEMP-ssh-from-home | Inbound | 22 | My home IP only | 

I used this once to get into the VM and then install Tailscale. 
Then I moved the real SSH onto the Tailscale interface. From there,
I deleted it since I didn't need it anymore.

## Azure's default rules

Every NSG comes with these and they can't be deleted. Inbound, Azure allows
traffic from inside the VNet and from its own load balancer, then denies
everything else. Outbound, it allows VNet and internet traffic.

## Where things stand

- **Public:** only TCP 22 and 23 are reachable from the internet, and both 
land in Cowrie. An external nmap scan of all 65,535 ports confirmed this
(documented in [assets](../../assets/)).

- **Admin access:** The real SSH listens on port 22222, bound only to the
VM's Tailscale IP. It has no NSG allow rule, so it's unreachable from the
internet.

- **Off Switch:** Setting the two Allow-Cowrie rules to Deny would stop all
public exposure instantly.

