#!/usr/bin/env bash

set -euo pipefail

#
# Resolve domains to A and AAAA records
#
# Usage:
#   ./scripts/resolve-domains.sh ws-domains.txt
#
# Output:
#   ws-resolved.csv
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain-file>"
    echo
    echo "Example:"
    echo "  $0 ws-domains.txt"
    exit 1
fi

DOMAIN_FILE="$1"

if [ ! -f "$DOMAIN_FILE" ]; then
    echo "Error: file not found: $DOMAIN_FILE"
    exit 1
fi

PREFIX="$(basename "$DOMAIN_FILE" -domains.txt)"
OUTPUT_FILE="${PREFIX}-resolved.csv"

echo "Creating: $OUTPUT_FILE"

echo "domain,record_type,ip_address" > "$OUTPUT_FILE"

TOTAL=$(wc -l < "$DOMAIN_FILE")
CURRENT=0

while read -r DOMAIN
do
    CURRENT=$((CURRENT + 1))

    printf "\r[%s/%s] %s" "$CURRENT" "$TOTAL" "$DOMAIN"

    dig +short A "$DOMAIN" |
    while read -r IP
    do
        [ -n "$IP" ] && \
        echo "$DOMAIN,A,$IP" >> "$OUTPUT_FILE"
    done

    dig +short AAAA "$DOMAIN" |
    while read -r IP
    do
        [ -n "$IP" ] && \
        echo "$DOMAIN,AAAA,$IP" >> "$OUTPUT_FILE"
    done

done < "$DOMAIN_FILE"

echo
echo "Finished."

RECORDS=$(tail -n +2 "$OUTPUT_FILE" | wc -l)

echo "DNS records collected: $RECORDS"
echo "Output: $OUTPUT_FILE"