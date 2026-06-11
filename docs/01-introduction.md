# Introduction

## Documentation Examples and RFC Best Practice

> [!IMPORTANT]
> Throughout this repository, example domain names, IPv4 addresses, and IPv6 addresses are taken from ranges reserved specifically for documentation, training, and educational purposes.
>
> This follows Internet Engineering Task Force (IETF) best practice and ensures that examples cannot accidentally interact with real systems, organisations, services, or networks.
>
> Unless explicitly stated otherwise, all examples use documentation-only resources defined by Internet standards.

### Documentation Domain Names

The following domain names are reserved for documentation and examples by RFC 2606:

```text
example.com
example.net
example.org
```

Throughout this repository, example country-code Top-Level Domains (ccTLDs) are represented using names such as:

```text
service.example.ws
government.example.fj
university.example.vu
bank.example.to
```

These names do not represent real services.

### Documentation IPv4 Addresses

RFC 5737 reserves three IPv4 address ranges for documentation purposes:

```text
192.0.2.0/24
198.51.100.0/24
203.0.113.0/24
```

Examples:

```text
192.0.2.10
198.51.100.20
203.0.113.30
```

### Documentation IPv6 Addresses

RFC 3849 reserves the following IPv6 prefix for documentation:

```text
2001:db8::/32
```

Examples:

```text
2001:db8::10
2001:db8:100::20
2001:db8:200::30
```

### Real-World Case Studies

Some chapters within this repository analyse real Internet infrastructure and real services.

When discussing actual measurements, Autonomous System Numbers (ASNs), domain names, IP addresses, hosting providers, or Internet Exchange Points (IXPs), the use of real data will be clearly identified.

The Samoa case study later in this repository uses actual measurement results and therefore contains real-world data.

### References

* [RFC 2606 – Reserved Top Level DNS Names](https://www.rfc-editor.org/rfc/rfc2606.txt)
* [RFC 5737 – IPv4 Address Blocks Reserved for Documentation](https://www.rfc-editor.org/rfc/rfc5737.txt)
* [RFC 3849 – IPv6 Address Prefix Reserved for Documentation](https://www.rfc-editor.org/rfc/rfc3849.txt)



# Purpose of This Project

This repository provides a practical methodology for analysing country-code Top-Level Domains (ccTLDs) using publicly available datasets, Domain Name System (DNS) information, Autonomous System Number (ASN) data, and open-source tools.

The goal is not simply to identify which domains exist within a country-code namespace. Instead, the methodology helps answer broader questions about Internet development, local hosting, content localisation, IPv6 deployment, and Internet infrastructure maturity.

The techniques described throughout this repository can be applied to any country-code Top-Level Domain.

Examples include:

| Country  | ccTLD |
| -------- | ----- |
| Samoa    | `.ws` |
| Fiji     | `.fj` |
| Vanuatu  | `.vu` |
| Tonga    | `.to` |
| Tuvalu   | `.tv` |
| Kiribati | `.ki` |

The same methodology can also be adapted to generic Top-Level Domains (gTLDs) such as `.com`, `.net`, and `.org`.



# Why Analyse a ccTLD?

Many countries invest significant resources into Internet infrastructure initiatives such as:

* Internet Exchange Points (IXPs)
* National fibre networks
* Data centres
* Content Delivery Networks (CDNs)
* IPv6 deployment programmes
* Local cloud infrastructure

These investments are intended to improve:

* Performance
* Reliability
* Resilience
* Affordability
* User experience

However, an important question often remains unanswered:

> How much locally relevant content is actually hosted locally?

A country may have:

* Thousands of registered domain names
* Hundreds of active websites
* Government portals
* Educational platforms
* Banking systems
* Media organisations

Yet many of these services may be hosted in another country or delivered via international cloud providers.

Understanding where content is hosted can provide valuable insight into how Internet infrastructure is being used and where opportunities for improvement may exist.



# What is a Top-Level Domain?

A Top-Level Domain (TLD) is the final component of a domain name.

Examples:

| Domain      | TLD    |
| ----------- | ------ |
| example.com | `.com` |
| example.net | `.net` |
| example.org | `.org` |

Country-code Top-Level Domains (ccTLDs) are two-letter domains associated with countries and territories.

Examples:

| Country   | ccTLD |
| --------- | ----- |
| Australia | `.au` |
| Samoa     | `.ws` |
| Fiji      | `.fj` |
| Vanuatu   | `.vu` |
| Tonga     | `.to` |

In many cases, ccTLDs are used by organisations and individuals connected to the corresponding country.

However, this is not always true.

Several ccTLDs have become globally popular and are frequently used by organisations with little or no connection to the country itself.

Examples include:

| ccTLD | Common Use                      |
| ----- | ------------------------------- |
| `.tv` | Television and media            |
| `.io` | Technology companies            |
| `.ai` | Artificial Intelligence         |
| `.to` | URL shortening and domain hacks |

As a result, analysing a ccTLD can reveal interesting differences between:

* Domain registration
* Content creation
* Content hosting
* Traffic localisation



# What is Cloudflare Radar?

Cloudflare Radar is a public Internet measurement platform that provides visibility into:

* Internet traffic trends
* Routing events
* Security activity
* Domain popularity

One of its publicly available datasets is the:

> Top 1 Million Domains

This dataset ranks domains based on observed Internet activity.

The dataset does **not** contain every registered domain.

Instead, it provides visibility into domains that are actively used and observed on the Internet.

This makes it particularly useful for research because it focuses on domains that people are actually accessing.

For example:

```text
service.example.ws
government.example.ws
bank.example.ws
```

may all be registered, but only some may appear within the Top 1 Million ranking.

Throughout this repository, the Cloudflare Radar dataset serves as the starting point for identifying active domains within a particular namespace.



# What Questions Can This Methodology Answer?

The workflow in this repository can help answer questions such as:

## Domain Popularity

* How many domains from a particular ccTLD appear in the Top 1 Million?
* Which domains are the most popular?

## DNS Activity

* Do the domains resolve successfully?
* Are they actively maintained?

## IPv6 Adoption

* How many domains publish IPv6 addresses?
* Are organisations deploying IPv6?

## Hosting Analysis

* Which cloud providers are being used?
* Which Autonomous Systems host the services?

## Content Localisation

* Are services hosted locally?
* Are they hosted internationally?
* Could they benefit from local Internet Exchange Points?

## Internet Ecosystem Development

* Is there evidence of local content creation?
* Is there evidence of local hosting?
* Is cloud infrastructure dominating the namespace?



# Understanding DNS

The Domain Name System (DNS) is often described as the Internet's phone book.

Humans prefer names such as:

```text
service.example.ws
```

Computers communicate using Internet Protocol (IP) addresses such as:

```text
203.0.113.20
```

DNS translates domain names into IP addresses.

For example:

```text
www.example.ws
      ↓
203.0.113.20
```

This allows users to access services without remembering numeric addresses.

DNS records can also reveal useful information about how services are deployed.



# Understanding IPv4 and IPv6

The Internet currently operates using two major addressing systems.

## IPv4

Internet Protocol Version 4 (IPv4) uses 32-bit addresses.

Example:

```text
203.0.113.20
```

IPv4 address space is finite and has effectively been exhausted globally.

## IPv6

Internet Protocol Version 6 (IPv6) uses 128-bit addresses.

Example:

```text
2001:db8:100::20
```

IPv6 provides a vastly larger address space and supports the long-term growth of the Internet.

One of the objectives of this repository is to measure IPv6 adoption within a ccTLD.



# Understanding Autonomous System Numbers

An Autonomous System (AS) is a network operated by a single organisation.

Each Autonomous System is identified by an Autonomous System Number (ASN).

Examples include:

| Organisation        | ASN     |
| ------------------- | ------- |
| Cloudflare          | AS13335 |
| Google              | AS15169 |
| Amazon Web Services | AS16509 |
| APNIC               | AS237   |

Autonomous Systems exchange routing information using the Border Gateway Protocol (BGP).

When a domain resolves to an IP address, it is often useful to determine:

* Which ASN announces the address?
* Which organisation owns the network?
* Which country hosts the infrastructure?

This information provides valuable insight into where services are actually hosted.



# Understanding Content Delivery Networks

A Content Delivery Network (CDN) is a distributed platform that delivers content from multiple locations.

Examples include:

* Cloudflare
* Akamai
* Fastly
* Amazon CloudFront

CDNs improve:

* Performance
* Availability
* Security

However, they can also make hosting analysis more difficult.

For example:

```text
service.example.ws
      ↓
198.51.100.20
```

may appear to be hosted in one country while the underlying content is actually hosted elsewhere.

CDNs frequently use:

* Anycast routing
* Global load balancing
* Distributed caching

As a result, DNS records alone do not always reveal the true hosting location.



# Understanding Content Localisation

Content localisation refers to hosting content within the country where it is primarily consumed.

Examples include:

* Government services
* Educational platforms
* Banking systems
* Local news organisations

Benefits may include:

* Lower latency
* Reduced international bandwidth usage
* Improved resilience
* Better user experience

However, content localisation is not the same as domain registration.

For example:

```text
service.example.ws
```

may be registered within a country's namespace while being hosted in:

* Sydney
* Singapore
* Los Angeles
* Frankfurt

This distinction is central to the methodology used throughout this repository.



# Relationship to Internet Exchange Points

An Internet Exchange Point (IXP) allows networks within a country or region to exchange traffic directly.

| Scenario | Traffic Path |
|----------|----------|
| Without an IXP | User → ISP A → International Transit → ISP B |
| With an IXP | User → ISP A → IXP → ISP B |

If content is hosted locally, an IXP may allow traffic to remain within the country.

If content is hosted internationally, an IXP alone cannot localise the traffic.

Understanding where content is hosted is therefore an important complement to IXP development initiatives.

---

# Scope and Limitations

This repository focuses on:

* DNS analysis
* IP address analysis
* ASN analysis
* Hosting analysis
* IPv6 analysis

The methodology does **not** guarantee the precise physical location of a service.

Modern Internet infrastructure frequently uses:

* CDNs
* Cloud hosting
* Anycast routing
* GeoDNS
* Global load balancing

Results should therefore be interpreted carefully and supported by multiple sources of evidence whenever possible.

---

# Next Steps

The next chapter explains the software packages used throughout this repository and provides installation instructions for Ubuntu.


Continue to:

```text
docs/02-prerequisites.md
```
