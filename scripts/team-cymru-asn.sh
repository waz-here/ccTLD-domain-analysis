#!/usr/bin/env bash

set -euo pipefail

#
# Query Team Cymru's IP-to-ASN mapping service using bulk mode.
#
# Usage:
#   ./scripts/team-cymru-asn.sh <ips-file>
#
# Example:
#   ./scripts/team-cymru-asn.sh ws-ips.txt
#
# Input:
#   One IPv4 or IPv6 address per line
#
# Output:
#   ws-asn.txt
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ips-file>"
    echo
    echo "Example:"
    echo "  $0 ws-ips.txt"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: file not found: $INPUT_FILE"
    exit 1
fi

if ! command -v nc >/dev/null 2>&1; then
    echo "Error: nc is not installed."
    echo "Install it with: sudo apt install netcat-openbsd"
    exit 1
fi

PREFIX="$(basename "$INPUT_FILE" -ips.txt)"
OUTPUT_FILE="${PREFIX}-asn.txt"

CLEAN_IPS="$(mktemp)"

grep -Ev '^[[:space:]]*$' "$INPUT_FILE" |
grep -Ev '^;' |
sort -u > "$CLEAN_IPS"

TOTAL_IPS="$(wc -l < "$CLEAN_IPS")"

if [ "$TOTAL_IPS" -eq 0 ]; then
    echo "Error: no IP addresses found in $INPUT_FILE"
    rm -f "$CLEAN_IPS"
    exit 1
fi

echo "Input file: $INPUT_FILE"
echo "Unique IP addresses: $TOTAL_IPS"
echo "Querying Team Cymru bulk IP-to-ASN service..."
echo

(
    echo begin
    echo verbose
    cat "$CLEAN_IPS"
    echo end
) | nc whois.cymru.com 43 > "$OUTPUT_FILE"

rm -f "$CLEAN_IPS"

echo "Output written to: $OUTPUT_FILE"
echo

echo "First few results:"
head "$OUTPUT_FILE"