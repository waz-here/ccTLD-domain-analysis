# Scripts README

This folder contains helper scripts for the ccTLD Domain Analysis Toolkit.

The scripts support a repeatable workflow for extracting ccTLD domains, resolving DNS records, calculating IPv6 adoption, mapping IP addresses to ASNs, identifying top hosting networks, discovering subdomains, and generating a Markdown report.

## Recommended workflow

Run the scripts from the root of the repository.

```bash
cd ccTLD-domain-analysis
chmod +x scripts/*.sh
```

## 1. Extract ccTLD domains

Use this script after downloading the Cloudflare Radar Top 1 Million Domains dataset.

```bash
./scripts/extract-cctld.sh ws cloudflare-top-1m.csv
```

Output.

```text
ws-domains.txt
```

## 2. Resolve domains

For small datasets, use the standard resolver.

```bash
./scripts/resolve-domains.sh ws-domains.txt
```

For larger datasets, use the parallel resolver.

```bash
./scripts/resolve-domains-parallel.sh ws-domains.txt 20
```

Output.

```text
ws-resolved.csv
```

## 3. Calculate IPv6 statistics

```bash
./scripts/calculate-ipv6-stats.sh ws-resolved.csv
```

Output.

```text
ws-ipv6-summary.txt
```

## 4. Extract unique IP addresses

```bash
./scripts/extract-unique-ips.sh ws-resolved.csv
```

Output.

```text
ws-ips.txt
```

## 5. Map IP addresses to ASNs

This uses Team Cymru’s bulk IP to ASN service.

```bash
./scripts/team-cymru-asn.sh ws-ips.txt
```

Output.

```text
ws-asn.txt
```

## 6. Generate top ASN summary

```bash
./scripts/top-asns.sh ws-asn.txt
```

Output.

```text
ws-top-asns.txt
```

## 7. Generate a Markdown report

Run this after the previous outputs have been created.

```bash
./scripts/generate-report.sh ws
```

Output.

```text
reports/ws-report.md
```

## Optional. Discover subdomains for a key domain

Use this for deeper analysis of important organisations, such as government, education, media, banking, telecommunications, or local hosting providers.

```bash
./scripts/discover-subdomains.sh example.ws
```

Output.

```text
example.ws-subdomains.txt
```

You can then resolve the discovered subdomains.

```bash
./scripts/resolve-domains-parallel.sh example.ws-subdomains.txt 10
```

## Script summary

| Script                        | Purpose                                               | Main input           | Main output               |
| ----------------------------- | ----------------------------------------------------- | -------------------- | ------------------------- |
| `extract-cctld.sh`            | Extract domains for one ccTLD from a domain dataset   | Cloudflare Radar CSV | `<tld>-domains.txt`       |
| `resolve-domains.sh`          | Resolve A and AAAA records                            | `<tld>-domains.txt`  | `<tld>-resolved.csv`      |
| `resolve-domains-parallel.sh` | Resolve A and AAAA records faster using parallel jobs | `<tld>-domains.txt`  | `<tld>-resolved.csv`      |
| `calculate-ipv6-stats.sh`     | Summarise IPv6 adoption from resolved DNS records     | `<tld>-resolved.csv` | `<tld>-ipv6-summary.txt`  |
| `extract-unique-ips.sh`       | Extract unique IPv4 and IPv6 addresses                | `<tld>-resolved.csv` | `<tld>-ips.txt`           |
| `team-cymru-asn.sh`           | Map IP addresses to ASNs using Team Cymru bulk lookup | `<tld>-ips.txt`      | `<tld>-asn.txt`           |
| `top-asns.sh`                 | Count the most common ASNs in the dataset             | `<tld>-asn.txt`      | `<tld>-top-asns.txt`      |
| `discover-subdomains.sh`      | Discover subdomains using passive sources             | Domain name          | `<domain>-subdomains.txt` |
| `generate-report.sh`          | Generate a Markdown report from toolkit outputs       | ccTLD label          | `reports/<tld>-report.md` |

## Example full run

```bash
./scripts/extract-cctld.sh ws cloudflare-top-1m.csv
./scripts/resolve-domains-parallel.sh ws-domains.txt 20
./scripts/calculate-ipv6-stats.sh ws-resolved.csv
./scripts/extract-unique-ips.sh ws-resolved.csv
./scripts/team-cymru-asn.sh ws-ips.txt
./scripts/top-asns.sh ws-asn.txt
./scripts/generate-report.sh ws
```

## Required tools

Install the common dependencies on Ubuntu or Debian.

```bash
sudo apt update
sudo apt install dnsutils jq curl netcat-openbsd
```

Optional tools for deeper subdomain discovery.

```bash
# Amass
sudo apt install amass

# Subfinder
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

## Notes and cautions

Do not browse or download content from unknown domains during bulk analysis. DNS, ASN and metadata analysis is usually safer than interacting with websites directly.

DNS results can vary by resolver and location. CDN and anycast services can also make hosting location difficult to prove from DNS and ASN data alone.

ASN country codes do not always prove the physical location of a service. Treat results as indicators that support further investigation.

If a script fails with a `bash\r` error, convert the file to Unix line endings.

```bash
sudo apt install dos2unix
dos2unix scripts/*.sh
```
