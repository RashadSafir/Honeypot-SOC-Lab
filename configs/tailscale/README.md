# Tailscale Policy (tailnet segmentation)

By default, every device on a tailnet can reach every other device. That
would let a compromised honeypot reach my Pi and laptop, so I replaced the
allow-all rule with tags and specific grants.

## Tags

| Tag | Device |
|---|---|
| `tag:honeypot` | Azure VM (Cowrie) |
| `tag:soc` | Raspberry Pi (Wazuh, will be implemented soon) |

My laptop stays untagged, owned by my user

## What's allowed

| From | To | Ports | Why |
|---|---|---|---|
| My devices | each other | all | normal use |
| My devices | Pi | all | SSH now, Wazuh dashboard later |
| My devices | VM | 22222 | admin SSH |
| VM | Pi | 1514, 1515 | Wazuh agent → manager |

Everything else is denied, including the VM reaching my laptop 
or any other port on the Pi.

The policy's `tests` block re-checks the important rules on every
save, and Tailscale rejects any change that breaks them.

## Verified

From the VM, the Pi's SSH and my laptop time out (blocked), while
the Pi's port 1514 is refused (allowed through, nothing listening
yet). See [`assets/`](../../assets/tailscale-acl-tests.txt).