#!/usr/bin/env bash

set -euo pipefail

#
# Generate a Top ASN summary from Team Cymru bulk output.
#
# Usage:
#   ./scripts/top-asns.sh <asn-file>
#
# Example:
#   ./scripts/top-asns.sh ws-asn.txt
#
# Input:
#   Team Cymru bulk output
#
# Output:
#   ws-top-asns.txt
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <asn-file>"
    echo
    echo "Example:"
    echo "  $0 ws-asn.txt"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: file not found: $INPUT_FILE"
    exit 1
fi

PREFIX="$(basename "$INPUT_FILE" -asn.txt)"
OUTPUT_FILE="${PREFIX}-top-asns.txt"

tail -n +2 "$INPUT_FILE" |
awk -F'|' '
{
    asn=$1
    name=$7

    gsub(/^[ \t]+|[ \t]+$/, "", asn)
    gsub(/^[ \t]+|[ \t]+$/, "", name)

    if (asn != "" && asn != "NA") {
        count[asn]++
        asname[asn]=name
    }
}
END {
    for (asn in count) {
        print count[asn] "," "AS" asn "," asname[asn]
    }
}
' |
sort -t, -k1,1nr > "$OUTPUT_FILE"

echo "Top ASN report written to: $OUTPUT_FILE"
echo
echo "Top 20 ASNs:"
echo
printf "%-8s %-12s %s\n" "Count" "ASN" "Organisation"
printf "%-8s %-12s %s\n" "-----" "---" "------------"

head -20 "$OUTPUT_FILE" |
awk -F, '{ printf "%-8s %-12s %s\n", $1, $2, $3 }'