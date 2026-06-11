#!/usr/bin/env bash

set -euo pipefail

# Extract domains for a selected country-code Top-Level Domain (ccTLD)
# from the Cloudflare Radar Top 1 Million Domains dataset.
#
# Usage:
#   ./scripts/extract-cctld.sh ws cloudflare-top-1m.csv
#
# Output:
#   ws-domains.txt

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <tld-without-dot> <input-csv>"
    echo
    echo "Example:"
    echo "  $0 ws cloudflare-top-1m.csv"
    exit 1
fi

TLD="$1"
INPUT_FILE="$2"
OUTPUT_FILE="${TLD}-domains.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: input file not found: $INPUT_FILE"
    exit 1
fi

# Normalise the TLD:
# - remove a leading dot if the user entered ".ws"
# - convert to lowercase
TLD="$(echo "$TLD" | sed 's/^\.//' | tr '[:upper:]' '[:lower:]')"

echo "Extracting .$TLD domains from: $INPUT_FILE"

# This script assumes the domain is in the first CSV column.
# If your file has rank,domain columns, change $1 to $2 below.
awk -F, -v tld="$TLD" '
    tolower($1) ~ "\\." tld "$" {
        print tolower($1)
    }
' "$INPUT_FILE" | sort -u > "$OUTPUT_FILE"

COUNT="$(wc -l < "$OUTPUT_FILE")"

echo "Done."
echo "Domains found: $COUNT"
echo "Output written to: $OUTPUT_FILE"