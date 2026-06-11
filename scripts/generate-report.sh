#!/usr/bin/env bash

set -euo pipefail

#
# Generate a Markdown report from ccTLD analysis outputs.
#
# Usage:
#   ./scripts/generate-report.sh <tld>
#
# Example:
#   ./scripts/generate-report.sh ws
#
# Expected input files:
#   ws-domains.txt
#   ws-resolved.csv
#   ws-ips.txt
#   ws-asn.txt
#   ws-top-asns.txt
#   ws-ipv6-summary.txt
#
# Output:
#   reports/ws-report.md
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <tld-without-dot>"
    echo
    echo "Example:"
    echo "  $0 ws"
    exit 1
fi

TLD="$(echo "$1" | sed 's/^\.//' | tr '[:upper:]' '[:lower:]')"

DOMAINS_FILE="${TLD}-domains.txt"
RESOLVED_FILE="${TLD}-resolved.csv"
IPS_FILE="${TLD}-ips.txt"
ASN_FILE="${TLD}-asn.txt"
TOP_ASNS_FILE="${TLD}-top-asns.txt"
IPV6_SUMMARY_FILE="${TLD}-ipv6-summary.txt"

REPORT_DIR="reports"
REPORT_FILE="${REPORT_DIR}/${TLD}-report.md"

mkdir -p "$REPORT_DIR"

for file in "$DOMAINS_FILE" "$RESOLVED_FILE" "$IPS_FILE" "$ASN_FILE" "$TOP_ASNS_FILE" "$IPV6_SUMMARY_FILE"
do
    if [ ! -f "$file" ]; then
        echo "Error: required file not found: $file"
        exit 1
    fi
done

TOTAL_DOMAINS="$(wc -l < "$DOMAINS_FILE")"
RESOLVED_DOMAINS="$(tail -n +2 "$RESOLVED_FILE" | cut -d, -f1 | sort -u | wc -l)"
TOTAL_IPS="$(wc -l < "$IPS_FILE")"
IPV4_IPS="$(grep -vc ':' "$IPS_FILE" || true)"
IPV6_IPS="$(grep -c ':' "$IPS_FILE" || true)"
IPV6_DOMAINS="$(awk -F, '$2=="AAAA" {print $1}' "$RESOLVED_FILE" | sort -u | wc -l)"

if [ "$RESOLVED_DOMAINS" -eq 0 ]; then
    IPV6_RATE="0.00"
else
    IPV6_RATE="$(awk -v ipv6="$IPV6_DOMAINS" -v total="$RESOLVED_DOMAINS" 'BEGIN { printf "%.2f", (ipv6 * 100) / total }')"
fi

TOP_ASN_COUNT="$(head -1 "$TOP_ASNS_FILE" | cut -d, -f1)"
TOP_ASN="$(head -1 "$TOP_ASNS_FILE" | cut -d, -f2)"
TOP_ASN_NAME="$(head -1 "$TOP_ASNS_FILE" | cut -d, -f3-)"

DATE_UTC="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

cat > "$REPORT_FILE" << EOF
# .$TLD Domain Analysis Report

Generated: $DATE_UTC

## Overview

This report summarises analysis of domains ending in \`.$TLD\` using DNS, IPv6, Autonomous System Number (ASN), cloud, and Content Delivery Network (CDN) indicators.

The analysis is based on domains extracted from the Cloudflare Radar Top 1 Million Domains dataset and processed using the ccTLD Domain Analysis Toolkit.

---

## Summary Statistics

| Metric | Value |
|----------|----------:|
| Domains found in dataset | $TOTAL_DOMAINS |
| Domains resolving to IP addresses | $RESOLVED_DOMAINS |
| Unique IP addresses observed | $TOTAL_IPS |
| IPv4 addresses observed | $IPV4_IPS |
| IPv6 addresses observed | $IPV6_IPS |
| Domains with IPv6 | $IPV6_DOMAINS |
| IPv6 adoption rate | $IPV6_RATE% |

---

## Top ASN

| Metric | Value |
|----------|----------|
| Most common ASN | $TOP_ASN |
| Organisation | $TOP_ASN_NAME |
| Observed IP count | $TOP_ASN_COUNT |

---

## Top ASNs

| Count | ASN | Organisation |
|----------:|----------|----------|
EOF

head -20 "$TOP_ASNS_FILE" |
awk -F, '{ printf "| %s | %s | %s |\n", $1, $2, $3 }' >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## IPv6 Summary

\`\`\`text
$(cat "$IPV6_SUMMARY_FILE")
\`\`\`

---

## Interpretation Notes

### IPv6

The IPv6 adoption rate in this report is based on domains that publish AAAA records.

This should be interpreted as:

> The percentage of resolved domains that appear reachable over IPv6.

It should not automatically be interpreted as:

> The percentage of organisations that have intentionally deployed IPv6.

Cloud providers and CDNs may enable IPv6 automatically for hosted or proxied domains.

### CDN and Cloud Providers

Large counts for ASNs such as Cloudflare, Amazon Web Services, Google, Microsoft, Akamai, or Fastly may indicate significant use of global cloud or CDN infrastructure.

However, CDN usage can hide the true origin server location.

### Local Hosting

Locally hosted services are usually identified by local ASNs, local Internet Service Providers, universities, government networks, or local data centre operators.

Further service-level analysis is recommended for key organisations.

---

## Suggested Follow-Up Analysis

Recommended next steps:

1. Identify government, education, media, banking, and telecommunications domains.
2. Perform subdomain discovery for key organisations.
3. Compare apex domains with service-specific subdomains.
4. Investigate whether important services are locally hosted or cloud hosted.
5. Check whether locally hosted services support IPv6.
6. Consider safe reputation checks before browsing unknown domains.

---

## Files Used

| File | Purpose |
|----------|----------|
| \`$DOMAINS_FILE\` | Extracted .$TLD domains |
| \`$RESOLVED_FILE\` | DNS A and AAAA records |
| \`$IPS_FILE\` | Unique IP addresses |
| \`$ASN_FILE\` | Team Cymru ASN results |
| \`$TOP_ASNS_FILE\` | Top ASN summary |
| \`$IPV6_SUMMARY_FILE\` | IPv6 summary |

---

## Limitations

This report uses DNS and ASN metadata.

It does not prove the exact physical location of hosting infrastructure.

Important limitations include:

- CDNs may hide origin servers.
- Cloud providers use global infrastructure.
- Anycast routing may change observed paths.
- DNS answers can vary by resolver and location.
- ASN country codes do not always indicate server location.

Results should be interpreted as indicators rather than absolute proof.

EOF

echo "Report generated: $REPORT_FILE"