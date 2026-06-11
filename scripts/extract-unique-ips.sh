#!/usr/bin/env bash

set -euo pipefail

#
# Extract unique IPv4 and IPv6 addresses from a resolved DNS CSV file.
#
# Usage:
#   ./scripts/extract-unique-ips.sh <resolved-csv>
#
# Example:
#   ./scripts/extract-unique-ips.sh ws-resolved.csv
#
# Input CSV format:
#   domain,record_type,ip_address
#
# Output:
#   ws-ips.txt
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <resolved-csv>"
    echo
    echo "Example:"
    echo "  $0 ws-resolved.csv"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: file not found: $INPUT_FILE"
    exit 1
fi

PREFIX="$(basename "$INPUT_FILE" -resolved.csv)"
OUTPUT_FILE="${PREFIX}-ips.txt"

tail -n +2 "$INPUT_FILE" |
cut -d, -f3 |
grep -Ev '^[[:space:]]*$' |
grep -Ev '^;' |
sort -u > "$OUTPUT_FILE"

TOTAL_IPS="$(wc -l < "$OUTPUT_FILE")"
IPV4_COUNT="$(grep -vc ':' "$OUTPUT_FILE" || true)"
IPV6_COUNT="$(grep -c ':' "$OUTPUT_FILE" || true)"

echo "Input file: $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"
echo
echo "Unique IP addresses: $TOTAL_IPS"
echo "IPv4 addresses: $IPV4_COUNT"
echo "IPv6 addresses: $IPV6_COUNT"