# CDN and Cloud Hosting Analysis

## Overview

In the previous chapter we mapped IP addresses to Autonomous System Numbers (ASNs).

ASN analysis tells us:

* Which networks host services.
* Which cloud providers are used.
* Which Content Delivery Networks (CDNs) are involved.
* Whether services appear to be locally hosted or externally hosted.

This chapter builds on the ASN analysis and focuses on understanding:

> Where content is actually being delivered from.

Understanding CDN and cloud usage is important because domain registration alone does not reveal where content is hosted.

For example:

```text
service.example.ws
```

may:

* Be hosted locally.
* Be hosted in a public cloud.
* Be delivered via a CDN.
* Use a combination of all three.



# Learning Objectives

By the end of this chapter you will be able to:

* Identify major cloud providers.
* Identify CDN operators.
* Categorise hosting platforms.
* Understand how CDNs influence DNS results.
* Interpret ASN statistics.
* Recognise limitations of DNS-based hosting analysis.
* Identify opportunities for content localisation.



# What is a Content Delivery Network?

A Content Delivery Network (CDN) is a distributed system that delivers content from multiple locations around the world.

Examples include:

* Cloudflare
* Akamai
* Fastly
* Amazon CloudFront

Rather than serving content from a single server, a CDN delivers content from infrastructure located closer to users.

Benefits include:

* Lower latency
* Improved performance
* Better resilience
* DDoS protection
* Reduced bandwidth costs



# What is Cloud Hosting?

Cloud hosting refers to running services on infrastructure provided by a cloud platform.

Examples include:

| Provider                  | Common ASN |
| ------------------------- | ---------- |
| Amazon Web Services (AWS) | AS16509    |
| Google Cloud              | AS15169    |
| Microsoft Azure           | AS8075     |
| DigitalOcean              | AS14061    |
| Oracle Cloud              | AS31898    |

Cloud platforms provide:

* Virtual machines
* Storage
* Databases
* Networking
* Managed services

Unlike CDNs, cloud providers generally host the origin application itself.



# Why Does This Matter?

When analysing a ccTLD, we often want to understand:

> How much content is hosted locally?

An Internet Exchange Point (IXP) can only keep traffic local if the content itself is available locally.

If a website is hosted in:

* Sydney
* Singapore
* Tokyo
* Los Angeles

then traffic must still leave the country, regardless of whether an IXP exists.

This makes hosting analysis an important complement to IXP analysis.



# Understanding CDN Bias

One of the most important lessons from real-world ccTLD analysis is:

> DNS records do not necessarily reveal where content originates.

For example:

```text
service.example.ws
```

may resolve to:

```text
198.51.100.20
```

which belongs to:

```text
AS13335
Cloudflare
```

This tells us:

* The domain uses Cloudflare.
* Traffic may be served from Cloudflare caches.
* The origin server may be hidden.
* The actual hosting location may be unknown.

This is a common limitation of DNS-based measurements.



# Real Example: Samoa (.ws)

The following results were observed during a real-world analysis of domains within the `.ws` namespace.

Top ASNs identified:

| ASN     | Count |
| ------- | ----- |
| AS13335 | 364   |
| AS16509 | 44    |
| AS63949 | 26    |
| AS24940 | 18    |
| AS54113 | 17    |

The dominant ASN was:

```text
AS13335
Cloudflare
```

representing:

```text
364 IP addresses
```

out of:

```text
586 unique IP addresses
```

identified during the analysis.



# What Does This Tell Us?

At first glance, one might conclude:

> Most .ws content is hosted by Cloudflare.

However, that would be incorrect.

A more accurate statement is:

> Most observed .ws IP addresses belonged to Cloudflare infrastructure.

Cloudflare is primarily:

* A CDN
* A reverse proxy
* A security platform

Many of the underlying origin servers remain hidden.



# Example Interpretation

Suppose a domain resolves to:

```text
AS13335
Cloudflare
```

Possible explanations include:

| Scenario         | Description                          |
| ---------------- | ------------------------------------ |
| CDN              | Content delivered via Cloudflare     |
| Reverse proxy    | Origin hidden behind Cloudflare      |
| Security service | Cloudflare providing DDoS protection |
| Cloudflare Pages | Hosted directly on Cloudflare        |

Without additional investigation, DNS alone cannot distinguish between these cases.



# Identifying Major Cloud Providers

Create a summary of common cloud-related ASNs.

Example:

| ASN     | Organisation        |
| ------- | ------------------- |
| AS16509 | Amazon Web Services |
| AS15169 | Google              |
| AS8075  | Microsoft           |
| AS14061 | DigitalOcean        |
| AS31898 | Oracle Cloud        |

Search for specific ASNs:

```bash
grep "16509" asn.txt | head
```

Example output:

```text
16509 | 198.51.100.20 | ... | AMAZON-02
```



# Cloud vs CDN

The distinction is important.

| CDN        | Cloud Provider  |
| ---------- | --------------- |
| Cloudflare | AWS             |
| Akamai     | Google Cloud    |
| Fastly     | Microsoft Azure |
| CloudFront | DigitalOcean    |

CDNs primarily deliver content.

Cloud providers primarily host applications and services.

A single website may use both.

Example:

```text
Website
   ↓
Cloudflare CDN
   ↓
AWS Origin Server
```



# Create a Hosting Classification Table

A useful approach is to classify services into categories.

| Category      | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| Local Hosting | Hosted by a local ISP, university, government, or data centre |
| Cloud Hosting | Hosted on AWS, Google Cloud, Azure, etc.                      |
| CDN Hosting   | Delivered through Cloudflare, Akamai, Fastly, etc.            |
| Hybrid        | Combination of local, cloud, and CDN infrastructure           |
| Unknown       | Unable to determine confidently                               |



# Local Hosting Indicators

Indicators of local hosting may include:

* Local ASN
* Local ISP address space
* Local university network
* Government-owned network
* National data centre

Example:

```text
ASXXXXX
National ISP
```

This may suggest:

> Traffic can potentially remain within the country.



# Cloud Hosting Indicators

Indicators of cloud hosting include:

```text
AS16509
Amazon Web Services
```

```text
AS15169
Google
```

```text
AS8075
Microsoft
```

These services are often hosted internationally.



# CDN Indicators

Indicators of CDN usage include:

```text
AS13335
Cloudflare
```

```text
AS20940
Akamai
```

```text
AS54113
Fastly
```

These networks frequently appear during ccTLD analysis.



# Investigating Specific Domains

If a domain appears important, perform additional checks.

Example:

```bash
dig +short service.example.ws
```

Check mail servers:

```bash
dig MX service.example.ws
```

Check nameservers:

```bash
dig NS service.example.ws
```

Investigate certificates:

```bash
curl -s "https://crt.sh/?q=%.example.ws&output=json"
```

These techniques often reveal more information than the website itself.



# Understanding Hidden Origins

Many modern websites intentionally hide their origin servers.

Reasons include:

* Security
* DDoS protection
* Load balancing
* Performance

As a result:

```text
Cloudflare ASN
```

does not necessarily mean:

```text
Cloudflare Hosting
```

This distinction is extremely important when interpreting results.



# Content Localisation Opportunities

Hosting analysis can reveal opportunities for local infrastructure development.

Examples include:

* Government services hosted offshore
* Educational platforms hosted offshore
* Media content hosted offshore
* Local organisations using international cloud services

These observations can support discussions around:

* IXPs
* Local data centres
* CDN deployments
* Cloud adoption strategies



# Suggested Statistics

The following metrics are useful for reports.

## Top ASNs

| ASN     | Organisation     | Count |
| ------- | ---------------- | ----- |
| AS13335 | Cloudflare       | 364   |
| AS16509 | AWS              | 44    |
| AS63949 | Example Provider | 26    |

## Hosting Categories

| Category       | Domains |
| -------------- | ------- |
| CDN Hosted     | X       |
| Cloud Hosted   | Y       |
| Locally Hosted | Z       |

## Cloud Providers

| Provider   | Domains |
| ---------- | ------- |
| Cloudflare | X       |
| AWS        | Y       |
| Google     | Z       |



# Common Mistakes

## Assuming ASN Equals Hosting Location

Incorrect:

> Cloudflare ASN means the website is hosted in the United States.

Correct:

> Cloudflare ASN indicates traffic is delivered via Cloudflare infrastructure.



## Assuming CDN Equals Cloud Hosting

Incorrect:

> Cloudflare is the hosting provider.

Correct:

> Cloudflare may only be delivering content on behalf of another hosting provider.



## Assuming Registration Equals Hosting

Incorrect:

> A .ws domain is hosted in Samoa.

Correct:

> A .ws domain is registered within the Samoa namespace but may be hosted anywhere.



# Security Considerations

This chapter relies primarily on DNS and ASN data.

Avoid:

* Visiting unknown websites.
* Downloading files from untrusted domains.
* Assuming a domain is safe because it belongs to a ccTLD.

When investigating unknown domains, use:

* VirusTotal
* AbuseIPDB
* URLhaus
* Cisco Talos

rather than browsing directly.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
top-asns.txt
hosting-summary.txt
```

and a better understanding of:

* Cloud providers
* CDN providers
* Local hosting
* Content localisation opportunities

---

# What Comes Next?

The next chapter focuses on identifying:

* Government services
* Universities
* Schools
* Banks
* Media organisations

and understanding their significance for Internet development and content localisation.

Continue to:

```text
docs/09-identifying-key-organisations.md
```
