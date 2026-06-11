#!/usr/bin/env bash

set -euo pipefail

#
# Calculate IPv6 adoption statistics from a resolved DNS CSV file.
#
# Usage:
#   ./scripts/calculate-ipv6-stats.sh <resolved-csv>
#
# Example:
#   ./scripts/calculate-ipv6-stats.sh ws-resolved.csv
#
# Input CSV format:
#   domain,record_type,ip_address
#
# Output:
#   ws-ipv6-summary.txt
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
OUTPUT_FILE="${PREFIX}-ipv6-summary.txt"

TOTAL_DOMAINS="$(tail -n +2 "$INPUT_FILE" | cut -d, -f1 | sort -u | wc -l)"
IPV4_DOMAINS="$(awk -F, '$2=="A" {print $1}' "$INPUT_FILE" | sort -u | wc -l)"
IPV6_DOMAINS="$(awk -F, '$2=="AAAA" {print $1}' "$INPUT_FILE" | sort -u | wc -l)"
IPV4_RECORDS="$(awk -F, '$2=="A"' "$INPUT_FILE" | wc -l)"
IPV6_RECORDS="$(awk -F, '$2=="AAAA"' "$INPUT_FILE" | wc -l)"

if [ "$TOTAL_DOMAINS" -eq 0 ]; then
    IPV6_RATE="0.00"
else
    IPV6_RATE="$(awk -v ipv6="$IPV6_DOMAINS" -v total="$TOTAL_DOMAINS" 'BEGIN { printf "%.2f", (ipv6 * 100) / total }')"
fi

cat << EOF > "$OUTPUT_FILE"
IPv6 Summary
============

Input file: $INPUT_FILE

Domains analysed: $TOTAL_DOMAINS
Domains with IPv4: $IPV4_DOMAINS
Domains with IPv6: $IPV6_DOMAINS
IPv6 adoption rate: $IPV6_RATE%

IPv4 records observed: $IPV4_RECORDS
IPv6 records observed: $IPV6_RECORDS
EOF

cat "$OUTPUT_FILE"

echo
echo "Output written to: $OUTPUT_FILE"
