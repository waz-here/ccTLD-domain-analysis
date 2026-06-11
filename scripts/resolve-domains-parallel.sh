#!/usr/bin/env bash

set -euo pipefail

#
# Resolve domains to A and AAAA records in parallel.
#
# Usage:
#   ./scripts/resolve-domains-parallel.sh <domain-file> [parallel-jobs]
#
# Example:
#   ./scripts/resolve-domains-parallel.sh ws-domains.txt
#   ./scripts/resolve-domains-parallel.sh ws-domains.txt 20
#
# Output:
#   ws-resolved.csv
#

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <domain-file> [parallel-jobs]"
    echo
    echo "Examples:"
    echo "  $0 ws-domains.txt"
    echo "  $0 ws-domains.txt 20"
    exit 1
fi

DOMAIN_FILE="$1"
PARALLEL_JOBS="${2:-10}"

if [ ! -f "$DOMAIN_FILE" ]; then
    echo "Error: file not found: $DOMAIN_FILE"
    exit 1
fi

if ! command -v dig >/dev/null 2>&1; then
    echo "Error: dig is not installed."
    echo "Install it with: sudo apt install dnsutils"
    exit 1
fi

if ! [[ "$PARALLEL_JOBS" =~ ^[0-9]+$ ]] || [ "$PARALLEL_JOBS" -lt 1 ]; then
    echo "Error: parallel-jobs must be a positive number."
    exit 1
fi

PREFIX="$(basename "$DOMAIN_FILE" -domains.txt)"
OUTPUT_FILE="${PREFIX}-resolved.csv"
TEMP_FILE="$(mktemp)"

echo "Input file: $DOMAIN_FILE"
echo "Output file: $OUTPUT_FILE"
echo "Parallel jobs: $PARALLEL_JOBS"
echo

echo "domain,record_type,ip_address" > "$OUTPUT_FILE"

resolve_domain() {
    domain="$1"

    dig +short A "$domain" 2>/dev/null |
    grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' |
    while read -r ip
    do
        echo "$domain,A,$ip"
    done

    dig +short AAAA "$domain" 2>/dev/null |
    grep -E ':' |
    while read -r ip
    do
        echo "$domain,AAAA,$ip"
    done
}

export -f resolve_domain

cat "$DOMAIN_FILE" |
grep -v '^[[:space:]]*$' |
xargs -P "$PARALLEL_JOBS" -I {} bash -c 'resolve_domain "$@"' _ {} > "$TEMP_FILE"

sort -u "$TEMP_FILE" >> "$OUTPUT_FILE"

rm -f "$TEMP_FILE"

TOTAL_RECORDS="$(tail -n +2 "$OUTPUT_FILE" | wc -l)"
TOTAL_DOMAINS="$(tail -n +2 "$OUTPUT_FILE" | cut -d, -f1 | sort -u | wc -l)"
IPV4_RECORDS="$(awk -F, '$2=="A"' "$OUTPUT_FILE" | wc -l)"
IPV6_RECORDS="$(awk -F, '$2=="AAAA"' "$OUTPUT_FILE" | wc -l)"

echo "Finished."
echo "DNS records collected: $TOTAL_RECORDS"
echo "Domains resolved: $TOTAL_DOMAINS"
echo "IPv4 records: $IPV4_RECORDS"
echo "IPv6 records: $IPV6_RECORDS"
echo "Output written to: $OUTPUT_FILE"