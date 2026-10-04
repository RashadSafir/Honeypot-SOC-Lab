#!/usr/bin/env bash
# This file contains quick statistics of raw Cowrie logs (run on the VM as a sudo user)
# This was used to verify that the honeypot is collecting, and later to cross-check 
# Wazuh dashboards against source data. This excludes own test IPs listed in 
# ~/own-ips.txt 

# Saves the log folder path in a variable to avoid repetition
LOGDIR=/home/cowrie/my-honeypot/var/log/cowrie

# Pointed towards the excluded file, so that the script filters out my own tests
EXCL=~/own-ips.txt

# Creates a temporary file with a random name, and stores path in TMP
TMP=$(mktemp)

# Tells bash to delete temp file automatically when script ends. Just to make sure
# nothing gets left behind in /tmp.
trap 'rm -f "$TMP"' EXIT

# Joins all Cowrie log files (plus rotated ones) into the temp file.
sudo bash -c "cat $LOGDIR/cowrie.json*" > "$TMP"

echo "== Unique source IPs";      jq -r 'select(.eventid=="cowrie.session.connect") | .src_ip' "$TMP" | grep -vwFf "$EXCL" | sort -u | wc -l
echo "== Top IPs by logins";      jq -r 'select(.eventid|startswith("cowrie.login")) | .src_ip' "$TMP" | grep -vwFf "$EXCL" | sort | uniq -c | sort -rn | head
echo "== Login results";          jq -r 'select(.eventid|startswith("cowrie.login")) | .eventid' "$TMP" | sort | uniq -c
echo "== Top credentials";        jq -r 'select(.eventid|startswith("cowrie.login")) | "\(.username):\(.password)"' "$TMP" | sort | uniq -c | sort -rn | head
echo "== Top commands";           jq -r 'select(.eventid=="cowrie.command.input") | .input' "$TMP" | sort | uniq -c | sort -rn | head -20
echo "== Captured file hashes";   jq -r 'select(.eventid=="cowrie.session.file_download") | .shasum' "$TMP" | sort | uniq -c | sort -rn
echo "== VM health";              free -h; df -h /
