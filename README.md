# ccTLD Domain Analysis Toolkit

A practical toolkit for analysing country-code Top-Level Domains (ccTLDs) using publicly available datasets, Domain Name System (DNS) information, Autonomous System Number (ASN) data, and open-source tools.

This project helps researchers, Internet Exchange Point (IXP) operators, National Research and Education Networks (NRENs), students, policymakers, and network engineers understand how a country's domain namespace is being used and where services are hosted.

The toolkit can be used with any ccTLD, including:

* `.ws` (Samoa)
* `.fj` (Fiji)
* `.tv` (Tuvalu)
* `.vu` (Vanuatu)
* `.to` (Tonga)
* `.ki` (Kiribati)
* Any other country-code Top-Level Domain


# Why This Project Exists

Many countries have established Internet Exchange Points (IXPs) to enable local traffic exchange and improve network performance.

However, an important question often remains:

> How much locally relevant content is actually hosted locally?

A country's namespace may contain thousands of registered domains, but:

* Where are those services hosted?
* Are they using local infrastructure?
* Are they dependent on international cloud providers?
* Do they support Internet Protocol Version 6 (IPv6)?
* Could they benefit from local traffic exchange?

This toolkit provides a repeatable methodology to help answer those questions.



# What This Toolkit Measures

The toolkit can be used to investigate:

## Domain Popularity

Identify domains belonging to a specific ccTLD from the Cloudflare Radar Top 1 Million Domains dataset.

Examples:

```text
example.ws
example.fj
example.tv
```

## DNS Activity

Determine whether domains are active by examining:

* A records (IPv4)
* AAAA records (IPv6)
* Mail Exchange (MX) records
* Nameserver (NS) records

## IPv6 Adoption

Measure:

* Number of domains publishing IPv6 addresses
* Percentage of IPv6-enabled domains
* Differences between cloud-hosted and locally hosted services


## Hosting Infrastructure

Identify:

* Cloudflare
* Amazon Web Services (AWS)
* Google Cloud
* Microsoft Azure
* Fastly
* Akamai
* DigitalOcean
* Local Internet Service Providers (ISPs)


## Autonomous System Analysis

Map Internet Protocol (IP) addresses to:

* Autonomous System Numbers (ASNs)
* Network operators
* Countries
* Hosting providers


## Content Localisation

Investigate whether services are:

* Locally hosted
* Cloud hosted
* Content Delivery Network (CDN) hosted
* Hybrid architectures


## Internet Development Indicators

Generate evidence relating to:

* Internet ecosystem maturity
* Local hosting adoption
* IPv6 deployment
* CDN deployment
* Content localisation
* Potential IXP opportunities


# Repository Structure

```text
ccTLD-domain-analysis/
│
├── README.md
│
├── docs/
│   ├── 01-introduction.md
│   ├── 02-prerequisites.md
│   ├── 03-download-cloudflare-data.md
│   ├── 04-extract-cctld-domains.md
│   ├── 05-dns-analysis.md
│   ├── 06-ipv6-analysis.md
│   ├── 07-asn-analysis.md
│   ├── 08-cdn-and-cloud-analysis.md
│   ├── 09-subdomain-discovery.md
│   ├── 10-content-localisation.md
│   ├── 11-security-considerations.md
│   └── 12-reporting-and-analysis
│
├── scripts/
│   ├── extract-cctld.sh
│   ├── resolve-domains.sh
│   ├── calculate-ipv6-stats.sh
│   ├── extract-unique-ips.sh
│   ├── team-cymru-asn.sh
│   ├── top-asns.sh
│   ├── discover-subdomains.sh
│   └── generate-report.sh
│
├── examples/
│
└── sample-output/
```



# Methodology Overview

The workflow consists of six major stages.

## Stage 1 – Obtain Popular Domain Data

Download the Cloudflare Radar Top 1 Million Domains dataset.

Source:

https://radar.cloudflare.com/domains



## Stage 2 – Extract ccTLD Domains

Filter domains belonging to a specific country-code namespace.

Example:

```text
.ws
.fj
.tv
.vu
```


## Stage 3 – Resolve DNS Records

Identify:

* IPv4 addresses
* IPv6 addresses
* Active services


## Stage 4 – Map IP Addresses to ASNs

Determine:

* Network owner
* Hosting provider
* Country
* ASN

using Team Cymru's IP-to-ASN service.


## Stage 5 – Identify Hosting Platforms

Categorise infrastructure as:

* Local hosting
* Cloud hosting
* CDN hosting


## Stage 6 – Analyse Content Localisation

Investigate whether services are:

* Hosted locally
* Hosted internationally
* Potential candidates for local traffic exchange


# Example Research Questions

This toolkit can help answer questions such as:

### How many `.ws` domains appear in the Top 1 Million?

### How many publish IPv6 records?

### Which ASNs host the largest number of domains?

### Which cloud providers dominate the namespace?

### Are government services hosted locally?

### Are educational platforms hosted locally?

### How much locally relevant content exists?

### Could an IXP improve access to local services?

---

# Example Findings

Using the Samoa (`.ws`) namespace as a case study, analysis identified:

* Hundreds of active `.ws` domains in the Cloudflare Radar Top 1 Million dataset.
* Significant use of Cloudflare and other global cloud providers.
* Approximately 41% of sampled domains published IPv6 records.
* National University of Samoa educational platforms hosted on Samoa-connected infrastructure.
* Student email services delivered through Google Workspace.
* Evidence that content localisation and IPv6 deployment are separate challenges.

A detailed walkthrough is provided in:

```text
docs/12-case-study-nus-samoa.md
```

---

# Security Warning

Do not automatically browse or download content from unknown domains.

Large ccTLD datasets frequently contain:

* Phishing sites
* Malware distribution sites
* Gambling sites
* Adult content
* Domain parking pages
* Abandoned infrastructure

This project focuses on DNS, ASN, and metadata analysis rather than website interaction.

See:

```text
docs/11-security-considerations.md
```

for safe research practices.

---

# Quick Start

Install required packages:

```bash
sudo apt update

sudo apt install \
dnsutils \
jq \
netcat-openbsd \
curl \
whois
```

On macOS, most of these tools are preinstalled. Only `jq` (and optionally `wget`) need [Homebrew](https://brew.sh):

```bash
brew install jq wget
```

Download the Cloudflare Radar dataset:

```bash
wget \
"https://radar.cloudflare.com/charts/LargerTopDomainsTable/attachment?id=1257&top=1000000"
```

On macOS (or anywhere without `wget`), use `curl` instead:

```bash
curl -L -o cloudflare-radar_top-1000000-domains.csv \
"https://radar.cloudflare.com/charts/LargerTopDomainsTable/attachment?id=1257&top=1000000"
```

Extract `.ws` domains:

```bash
awk -F, 'tolower($1) ~ /\.ws$/ {print $0}' \
cloudflare-radar_top-1000000-domains.csv \
> ws-domains.txt
```

Resolve DNS records:

```bash
./scripts/resolve-domains.sh ws-domains.txt
```

Generate ASN statistics:

```bash
./scripts/team-cymru-asn.sh
```

See the `/docs` directory for a detailed explanation of every command.


# Further Reading

* Cloudflare Radar: https://radar.cloudflare.com
* APNIC: https://www.apnic.net
* RIPE NCC: https://www.ripe.net
* Team Cymru IP to ASN Mapping: https://www.team-cymru.com/ip-asn-mapping
* OWASP Amass: https://owasp.org/www-project-amass
* ProjectDiscovery Subfinder: https://github.com/projectdiscovery/subfinder
* ICANN Centralized Zone Data Service (CZDS): https://czds.icann.org
* Hurricane Electric BGP Toolkit: https://bgp.he.net

---

# Licence

This repository is intended for educational, research, and Internet measurement purposes.

Users are responsible for ensuring compliance with local laws, registry policies, and acceptable use requirements when conducting Internet measurements.
