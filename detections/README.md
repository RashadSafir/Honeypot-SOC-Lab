# Cowrie Detection Rules

Event levels for Cowrie events in Wazuh. Alerts are generated at level 3+ (`log_alerts_level`), which also decides what reaches the dashboards.

| Event | Level | Reason |
|---|---|---|
| `session.connect` | 2 | Constant scanner traffic, and would be too high-volume to index. |
| `session.closed` | 2 | Same reasoning as connect. |
| `session.params` | 0 | Since Cowrie emulates a terminal, it just reveals the fake architecture to an adversary, doesn't really reveal anything about the attacker.|
| `log.closed` | 0 | Session-recording bookkeeping. |
| `client.version` | 0 | Just gives info about client info. It's useful as a field, not an alert. |
| `client.kex` | 0 | HASSH fingerprint, could be useful as a field, not an alert. |
| `client.fingerprint` | 0 | This is just a public-key attempt, which doesn't matter for an alert alone. |
| `client.size` | 3 | This shows that the terminal is interactive, which has been rare in previous glance of stats. This seems alert worthy.|
| `client.var` | 3 | Same as size. |
| `client.malformed_packet` | 3 | Shows an adversary possibly probing, and rare from previous glance of stats.|
| `telnet.option` | 0 | Protocol negotiation. |
| `telnet.error` | 0 | Cowrie dropping a client it can't handle. |
| `telnet.exploit_attempt` | 12 | Very important, since based on named exploit attempt. |
| `login.success` | 3 | Success is decided by Cowrie's userdb, not the attacker. This is indexed for credential dashboards. |
| `login.failed` | 3 | Same behavior as success, same level. |
| `command.input` | 3 | Base level for all commands, however child rules will escalate specific ones. |
| `command.success` | 0 | Covered by `command.input`. |
| `command.failed` | 0 | Emulation gap (honeypot-quality metric). This is also covered by `command.input`. |
| `session.file_download` | 8 | Attacker placed a file on the honeypot (T1105). |
| `session.file_upload` | 8 | Same severity as download, with the source is the uploading IP. |
| `session.file_download.failed` | 3 | Keeps the dropper URL as an IOC, and low volume. |

## Correlation Rules (will contain more as more data comes in)
- **Brute force:** login attempts (success + fail) from the same `src_ip` within a timeframe.
- **Command escalation:** child rules on `command_input` for specific commands (like `wget`/`curl`).
