# Security and Reputation Analysis

## Overview

Throughout this repository we have analysed:

* Popular domains
* DNS records
* IPv6 deployment
* Autonomous System Numbers (ASNs)
* Cloud providers
* Content Delivery Networks (CDNs)
* Key organisations
* Content localisation

At this point, many readers naturally want to investigate domains further by opening websites in a web browser.

This chapter explains why that may not always be safe and introduces techniques for evaluating domains without directly visiting them.

The goal is to answer questions such as:

* Is this domain active?
* Is it legitimate?
* Has it been reported as malicious?
* Is it associated with spam, phishing, or malware?
* Can I investigate it safely?



# Learning Objectives

By the end of this chapter you will be able to:

* Understand the risks associated with unknown domains.
* Perform basic reputation checks.
* Use public reputation services.
* Investigate domains safely.
* Distinguish between DNS analysis and content analysis.
* Reduce the risk of accidental exposure to malicious content.



# Why Security Matters

Many country-code Top-Level Domains (ccTLDs) contain:

* Government websites
* Universities
* News organisations
* Businesses

However, they may also contain:

* Domain parking pages
* Spam domains
* Phishing sites
* Malware distribution sites
* Scam websites
* Expired domains

Popularity within a dataset does not necessarily mean a domain is trustworthy.

A domain can appear in a ranking because it receives significant traffic, including malicious traffic.



# Understanding the Risks

Directly visiting unknown websites can expose you to:

| Risk               | Description                                 |
| ------------------ | ------------------------------------------- |
| Phishing           | Attempts to steal credentials               |
| Malware            | Malicious software downloads                |
| Browser Exploits   | Attempts to exploit browser vulnerabilities |
| Tracking           | Collection of user information              |
| Scam Content       | Fraudulent or deceptive content             |
| Unwanted Downloads | Files automatically offered to users        |

While modern browsers provide substantial protection, caution is still recommended.



# Safe Investigation Principles

When analysing a large number of domains:

## Prefer Metadata Over Content

Focus on:

* DNS records
* ASN information
* MX records
* Nameserver records
* Certificate information

before visiting a website.



## Avoid Clicking Random Links

Do not assume a domain is safe simply because:

* It appears in the Cloudflare Top 1 Million.
* It uses a country-code Top-Level Domain.
* It belongs to a familiar category.



## Investigate in Stages

A recommended workflow is:

```text id="4u5m2u"
DNS
 ↓
ASN
 ↓
Reputation
 ↓
Optional Browser Visit
```

This approach reduces risk.



# Domain Reputation Services

Several services provide information about domain reputation.

Examples include:

| Service     | Purpose                         |
| ----------- | ------------------------------- |
| VirusTotal  | Malware and reputation analysis |
| AbuseIPDB   | Abuse reporting                 |
| URLhaus     | Malware URL tracking            |
| Cisco Talos | Reputation information          |
| crt.sh      | Certificate Transparency logs   |

These services allow investigation without directly visiting the website.



# VirusTotal

VirusTotal aggregates results from multiple security vendors.

A domain can be searched manually:

```text id="9g1lcl"
https://www.virustotal.com/
```

Typical information includes:

* Reputation score
* Security vendor detections
* Historical observations
* Related infrastructure

Questions to consider:

* Is the domain flagged by multiple vendors?
* Is it associated with phishing?
* Is it associated with malware?



# AbuseIPDB

AbuseIPDB tracks reports of abusive IP addresses.

Useful questions include:

* Has the IP been reported?
* How many reports exist?
* What type of abuse was reported?

Examples:

* Spam
* Brute-force attacks
* Malware distribution



# URLhaus

URLhaus focuses on malicious URLs.

It is particularly useful for identifying:

* Malware download locations
* Command and control infrastructure
* Active malware campaigns



# Cisco Talos

Cisco Talos provides reputation information for:

* Domains
* IP addresses
* Email infrastructure

It can be useful when analysing:

* Suspicious domains
* Email services
* Hosting providers



# Investigating Without a Browser

Often, a browser is unnecessary.

Many useful questions can be answered using DNS alone.

Example:

```bash id="sm8t7v"
dig A service.example.ws
```

```bash id="gqqjln"
dig AAAA service.example.ws
```

```bash id="cqlggw"
dig MX service.example.ws
```

```bash id="lnncf0"
dig NS service.example.ws
```

These commands reveal infrastructure without retrieving web content.



# Checking HTTP Headers

If additional information is required, HTTP headers can often be inspected without loading the full website.

Example:

```bash id="u4z3s6"
curl -I https://service.example.ws
```

Possible output:

```text id="mwdmku"
HTTP/2 200
server: cloudflare
```

This may reveal:

* CDN usage
* Web server software
* Redirect behaviour

without loading the website itself.



# Avoid Downloading Content

Avoid commands such as:

```bash id="t0v8h2"
wget https://unknown-domain.example/file.exe
```

unless there is a legitimate reason and appropriate security controls are in place.

This repository focuses on infrastructure analysis rather than content analysis.



# Browser Safety Recommendations

If a website must be visited:

## Use an Updated Browser

Ensure:

* Browser updates are current.
* Security patches are installed.



## Use Browser Protections

Enable:

* Safe Browsing
* Phishing protection
* Malware protection

These are enabled by default in most modern browsers.

## Consider an Isolated Environment

Examples include:

* Virtual machines
* Disposable virtual machines
* Dedicated research systems

This is particularly useful when investigating unfamiliar domains.

## Protecting Your Source IP Address

Most DNS and ASN analysis activities are low risk and do not require anonymity.

However, when investigating unfamiliar websites, some researchers prefer to use:

- A VPN
- A dedicated research Virtual Machine (VM)
- A cloud-hosted research system
- An isolated browser profile

These measures can help separate research activity from personal or organisational systems.

> [!TIP]
> For large-scale Internet measurements, a dedicated research Virtual Private Server (VPS) is often a better long-term solution than using a personal Internet connection.


# DNS Analysis Is Generally Safe

The workflow used throughout this repository primarily involves:

```bash id="fdvszn"
dig
```

```bash id="c0a1sz"
whois
```

```bash id="jlwmw0"
curl -I
```

```bash id="qghs9g"
nc whois.cymru.com 43
```

These activities generally:

* Do not execute code.
* Do not render web content.
* Do not download files.

They are considered relatively low risk.



# Understanding False Positives

Reputation services are useful but not perfect.

Possible scenarios include:

| Result     | Interpretation                 |
| ---------- | ------------------------------ |
| Clean      | No known issues                |
| Suspicious | Requires further investigation |
| Malicious  | Strong indication of abuse     |
| Unknown    | Insufficient data              |

A single alert should not automatically be treated as proof of malicious activity.



# Domain Parking

Many domains resolve successfully but do not host meaningful content.

Examples include:

* Parked domains
* Advertising pages
* Unused registrations

These domains may:

* Resolve correctly
* Appear active
* Generate DNS records

while contributing little to local content development.



# Reputation Analysis Workflow

A recommended workflow is:

```text id="cf0t4j"
Domain
  ↓
DNS Analysis
  ↓
ASN Analysis
  ↓
Reputation Check
  ↓
Optional Browser Visit
```

This minimises unnecessary exposure.



# Building a Reputation Inventory

Consider creating a spreadsheet.

Example:

| Domain             | ASN     | Reputation Status | Notes                   |
| ------------------ | ------- | ----------------- | ----------------------- |
| service.example.ws | AS13335 | Clean             | Cloudflare              |
| bank.example.ws    | AS16509 | Clean             | Banking service         |
| unknown.example.ws | ASXXXXX | Suspicious        | Further review required |

This helps track findings consistently.



# Common Mistakes

## Visiting Every Domain

Incorrect approach:

> Open every domain in a browser.

This increases risk and provides little additional value for infrastructure analysis.



## Assuming Popular Means Safe

Incorrect:

> The domain appears in the Top 1 Million, therefore it is trustworthy.

Popularity and trustworthiness are different concepts.



## Assuming a Reputation Service Is Always Correct

Incorrect:

> VirusTotal says it is malicious, therefore it must be malicious.

Correct:

> Reputation services provide indicators that should be considered alongside other evidence.



# Example Research Statement

A suitable statement for a report might be:

> Reputation checks were performed using publicly available reputation services. The analysis focused on DNS, hosting, and infrastructure characteristics rather than website content. No intrusive testing or authentication attempts were conducted.

This clearly describes the scope of the work.



# Limitations

This chapter focuses on passive investigation techniques.

It does not cover:

* Vulnerability scanning
* Penetration testing
* Authentication testing
* Malware analysis
* Digital forensics

Those activities require additional authorisation, controls, and expertise.



# Output Created in This Chapter

At the end of this chapter you may choose to create:

```text id="9t6z1h"
reputation-inventory.csv
```

Example:

```csv id="m97gnf"
domain,asn,reputation_status,notes
service.example.ws,AS13335,Clean,Cloudflare
bank.example.ws,AS16509,Clean,AWS
unknown.example.ws,ASXXXXX,Suspicious,Further review required
```

This file can complement the hosting and localisation inventories created in earlier chapters.

---

# What Comes Next?

The next chapter brings together everything learned throughout this repository.

You will learn how to:

* Produce summary statistics.
* Create tables suitable for reports and blog posts.
* Develop content localisation findings.
* Identify opportunities for local hosting.
* Present results to technical and non-technical audiences.

Continue to:

```text id="txd9c2"
docs/12-reporting-and-analysis.md
```
