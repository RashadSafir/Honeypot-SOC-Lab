# NSG Rules (vm-honeypot-nsg)

This is the network security group attached to the honeypot VM's network
interface. Azure checks rules from lowest priority number
to highest, so my custom rules sit at 100 and run before Azure's defaults.

## Custom rules

| Name | Direction | Port | Protocol | Source | Destination | Action | Priority |
|---|---|---|---|---|---|---|---|
| Deny-SMTP-out | Outbound | 25 | TCP | Any | Any | Deny | 100 |

I blocked outbound SMTP so that the VM can't send spam ever, 
if something were to go wrong with the honeypot. 


## Rules I've removed

| Name | Direction | Port | Source | Purpose |
|---|---|---|---|---|
| TEMP-ssh-from-home | Inbound | 22 | My home IP only | I used this once to get into the VM and then
install Tailscale. Then I moved the real SSH onto the Tailscale interface. From there, I deleted it
since I didn't need it anymore. |

## Azure's default rules

Every NSG comes with these and they can't be deleted. Inbound, Azure allows
traffic from inside the VNet and from its own load balancer, then denies
everything else. Outbound, it allows VNet and internet traffic.

## Where things stand

The VM is reached over Tailscale, with the real SSH listening on port
22222. (will be changed once Cowrie is installed/listening.)

