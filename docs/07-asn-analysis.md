# ASN Analysis

## Overview

In the previous chapters we:

1. Extracted domains belonging to a country-code Top-Level Domain (ccTLD).
2. Resolved those domains to IPv4 and IPv6 addresses.
3. Measured IPv6 adoption.

The next step is to determine:

> Who hosts those IP addresses?

To answer this question we map IP addresses to:

* Autonomous System Numbers (ASNs)
* Network operators
* Hosting providers
* Countries

This process is known as ASN analysis.

ASN analysis is one of the most valuable parts of the workflow because it reveals:

* Which cloud providers dominate a namespace.
* Whether services are locally hosted.
* Whether services are delivered through Content Delivery Networks (CDNs).
* Opportunities for content localisation.
* Potential benefits of Internet Exchange Points (IXPs).



# Learning Objectives

By the end of this chapter you will be able to:

* Understand what an ASN is.
* Map IP addresses to ASNs.
* Use Team Cymru's bulk IP-to-ASN service.
* Create ASN datasets.
* Identify major hosting providers.
* Generate ASN statistics.
* Prepare data for CDN and content localisation analysis.



# What is an Autonomous System?

An Autonomous System (AS) is a network operated by a single organisation.

Examples include:

| Organisation        | ASN     |
| ------------------- | ------- |
| Cloudflare          | AS13335 |
| Google              | AS15169 |
| Amazon Web Services | AS16509 |
| Meta                | AS32934 |
| Microsoft           | AS8075  |


Autonomous Systems exchange routing information using:

> Border Gateway Protocol (BGP)

Each Autonomous System is assigned a unique number called an:

> Autonomous System Number (ASN)



# Why is ASN Analysis Useful?

Suppose a domain resolves to:

```text
203.0.113.20
```

The IP address alone does not tell us much.

However, ASN analysis may reveal:

```text
AS13335
Cloudflare
```

This immediately tells us:

* The service is likely behind Cloudflare.
* Traffic may be delivered through a CDN.
* The hosting location may not be obvious from DNS alone.

ASN analysis therefore provides much more useful information than IP addresses alone.



# Input Files

This chapter uses:

```text
ips.txt
```

created during DNS analysis.

Example:

```text
203.0.113.20
198.51.100.20
2001:db8:100::20
```

Each line contains a unique IPv4 or IPv6 address.



# Why Use Team Cymru?

There are many ways to map IP addresses to ASNs.

Examples include:

* Regional Internet Registry WHOIS databases
* BGP Looking Glass servers
* Routing APIs
* Team Cymru

For large datasets, Team Cymru is often the easiest option because it supports:

* IPv4
* IPv6
* Bulk queries
* Fast responses
* Simple automation



# Understanding Team Cymru Bulk Mode

Rather than querying one IP at a time:

```bash
whois -h whois.cymru.com " -v 203.0.113.20"
```

we can submit hundreds or thousands of addresses in a single request.

This is considerably faster.



# Create the Query

Team Cymru bulk mode uses a simple format:

```text
begin
verbose
IP_ADDRESS
IP_ADDRESS
IP_ADDRESS
end
```

Example:

```text
begin
verbose
203.0.113.20
198.51.100.20
2001:db8:100::20
end
```



# Perform a Bulk Lookup

Use the following command:

```bash
(
echo begin
echo verbose
cat ips.txt
echo end
) | nc whois.cymru.com 43 > asn.txt
```



# What Does This Command Do?

| Component         | Purpose                    |
| ----------------- | -------------------------- |
| `echo begin`      | Start Team Cymru bulk mode |
| `echo verbose`    | Request detailed output    |
| `cat ips.txt`     | Send all IP addresses      |
| `echo end`        | End the request            |
| `nc`              | Connect to Team Cymru      |
| `whois.cymru.com` | Team Cymru lookup server   |
| `43`              | WHOIS service port         |
| `>`               | Save output                |
| `asn.txt`         | Output file                |



# Examine the Results

View the first few entries:

```bash
head asn.txt
```

Example:

```text
Bulk mode; whois.cymru.com

13335 | 198.51.100.20 | 198.51.100.0/24 | US | arin | 2014-03-28 | CLOUDFLARENET
15169 | 2001:db8:100::20 | 2001:db8::/32 | US | arin | 2000-01-01 | GOOGLE
```

Actual results will contain real ASNs and organisations.



# Understanding the Output

Each row contains:

| Field           | Description                |
| --------------- | -------------------------- |
| ASN             | Autonomous System Number   |
| IP Address      | Queried IP                 |
| Prefix          | Routed network prefix      |
| Country Code    | Registered country         |
| Registry        | Regional Internet Registry |
| Allocation Date | Prefix allocation date     |
| ASN Name        | Organisation name          |



# Important Limitation

The country code shown by Team Cymru represents:

> The registration country of the network allocation

It does **not** necessarily indicate:

* Physical hosting location
* User location
* CDN cache location

For example:

```text
AS13335
Cloudflare
US
```

does not mean the service is physically hosted in the United States.

It only reflects registration information.



# Count Unique ASNs

Extract ASN values:

```bash
tail -n +2 asn.txt |
cut -d'|' -f1 |
tr -d ' ' |
sort -u
```

This produces a list of unique ASNs.



# Count the Most Common ASNs

Determine which ASNs appear most frequently:

```bash
tail -n +2 asn.txt |
cut -d'|' -f1 |
tr -d ' ' |
sort |
uniq -c |
sort -nr |
head -20
```

Example:

```text
364 13335
44 16509
26 63949
18 24940
17 54113
```



# Understanding the Command

| Command      | Purpose              |                    |
| ------------ | -------------------- | ------------------ |
| `tail -n +2` | Skip header          |                    |
| `cut -d'     | ' -f1`               | Extract ASN column |
| `tr -d ' '`  | Remove spaces        |                    |
| `sort`       | Group identical ASNs |                    |
| `uniq -c`    | Count occurrences    |                    |
| `sort -nr`   | Sort largest first   |                    |
| `head -20`   | Display top 20       |                    |



# Why Count ASNs?

The most common ASNs often reveal:

* Major cloud providers
* CDN operators
* Hosting companies
* Local Internet Service Providers

This can provide an immediate overview of the namespace.

> [!NOTE]
> Example results from a real-world ccTLD analysis showed:
>
> - AS13335 (Cloudflare) represented the majority of observed IP addresses.
> - AS16509 (Amazon Web Services) was the second most common hosting platform.
> - Several local and regional networks were also identified.
>
> This illustrates how ASN analysis can quickly reveal whether a namespace is dominated by cloud platforms, CDNs, or locally hosted services.


# Create a Top ASN Report

Generate a reusable report:

```bash
tail -n +2 asn.txt |
cut -d'|' -f1 |
tr -d ' ' |
sort |
uniq -c |
sort -nr > top-asns.txt
```

View:

```bash
head top-asns.txt
```

Example:

```text
364 13335
44 16509
26 63949
```



# Identify the ASN Name

Locate all records belonging to a specific ASN.

Example:

```bash
grep "13335" asn.txt | head
```

Example output:

```text
13335 | 198.51.100.20 | ... | CLOUDFLARENET
```

This helps identify the organisation behind the ASN.



# Create an ASN Summary Table

A simple report can be created manually:

| ASN     | Organisation        | Count |
| ------- | ------------------- | ----- |
| AS13335 | Cloudflare          | 364   |
| AS16509 | Amazon Web Services | 44    |
| AS63949 | Example Provider    | 26    |

This format is useful for:

* Reports
* Blog posts
* Presentations
* Research papers



# Understanding IPv6 ASN Results

Team Cymru supports IPv6 lookups.

Example:

```text
15169 | 2001:db8:100::20 | ... | GOOGLE
```

No additional commands are required.

IPv4 and IPv6 addresses can be processed together.



# Identify Local Hosting Providers

One of the most useful parts of ASN analysis is identifying local operators.

Examples might include:

* National Internet Service Providers
* Government networks
* National Research and Education Networks
* Local data centres

A locally hosted service may appear as:

```text
ASXXXXX
Local ISP
```

rather than:

```text
AS13335
Cloudflare
```

or

```text
AS16509
Amazon Web Services
```

This distinction becomes important when analysing content localisation.



# Common Issues

## No Results Returned

Verify:

```bash
wc -l ips.txt
```

contains IP addresses.



## Connection Refused

Check Internet connectivity:

```bash
nc whois.cymru.com 43
```

and verify outbound TCP port 43 is permitted.



## Missing ASN Values

Some entries may appear as:

```text
NA
```

This can occur when:

* The address is no longer routed.
* The address cannot be matched.
* The lookup failed.

This is normal and usually affects only a small number of records.



# Security Considerations

Unlike DNS resolution, ASN lookups interact with an external service.

However:

* Only IP addresses are transmitted.
* No website content is retrieved.
* No code is executed.

The process is generally considered low risk.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
asn.txt
top-asns.txt
```

Example:

```text
ccTLD-analysis/
│
├── ips.txt
├── asn.txt
└── top-asns.txt
```

These files will be used in the next chapter to identify:

* Cloud providers
* CDNs
* Hosting platforms

---

# What Comes Next?

The next chapter uses ASN information to identify:

* Cloudflare
* Google
* Amazon Web Services
* Akamai
* Fastly
* DigitalOcean
* Other hosting providers

You will learn how to distinguish between:

* Locally hosted services
* Cloud-hosted services
* CDN-hosted services

Continue to:

```text
docs/08-cdn-and-cloud-analysis.md
```
