#!/usr/bin/env bash

set -euo pipefail

#
# Discover subdomains for a selected domain using passive sources.
#
# This script uses:
#   1. crt.sh Certificate Transparency search
#   2. Amass, if installed
#   3. Subfinder, if installed
#
# Usage:
#   ./scripts/discover-subdomains.sh <domain>
#
# Example:
#   ./scripts/discover-subdomains.sh example.ws
#
# Output:
#   example.ws-subdomains.txt
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    echo
    echo "Example:"
    echo "  $0 example.ws"
    exit 1
fi

DOMAIN="$1"
OUTPUT_FILE="${DOMAIN}-subdomains.txt"
TEMP_FILE="$(mktemp)"

echo "Discovering subdomains for: $DOMAIN"
echo "Output file: $OUTPUT_FILE"
echo

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is not installed."
    echo "Install it with: sudo apt install curl"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed."
    echo "Install it with: sudo apt install jq"
    exit 1
fi

echo "[1/3] Querying crt.sh..."

curl -s "https://crt.sh/?q=%25.${DOMAIN}&output=json" |
jq -r '.[].name_value' 2>/dev/null |
tr '\r' '\n' |
tr '\n' '\n' |
sed 's/\*\.//g' |
grep -Ei "(^|\\.)${DOMAIN}$" >> "$TEMP_FILE" || true

if command -v amass >/dev/null 2>&1; then
    echo "[2/3] Running Amass passive enumeration..."
    amass enum -passive -d "$DOMAIN" >> "$TEMP_FILE" || true
else
    echo "[2/3] Amass not installed. Skipping."
fi

if command -v subfinder >/dev/null 2>&1; then
    echo "[3/3] Running Subfinder passive enumeration..."
    subfinder -silent -d "$DOMAIN" >> "$TEMP_FILE" || true
elif [ -x "$HOME/go/bin/subfinder" ]; then
    echo "[3/3] Running Subfinder from ~/go/bin..."
    "$HOME/go/bin/subfinder" -silent -d "$DOMAIN" >> "$TEMP_FILE" || true
else
    echo "[3/3] Subfinder not installed. Skipping."
fi

grep -Ei "(^|\\.)${DOMAIN}$" "$TEMP_FILE" |
tr '[:upper:]' '[:lower:]' |
sort -u > "$OUTPUT_FILE"

rm -f "$TEMP_FILE"

COUNT="$(wc -l < "$OUTPUT_FILE")"

echo
echo "Finished."
echo "Subdomains found: $COUNT"
echo "Output written to: $OUTPUT_FILE"