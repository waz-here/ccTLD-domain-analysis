# IPv6 Analysis

## Overview

Now that DNS records have been collected, we can begin analysing IPv6 adoption within the selected country-code Top-Level Domain (ccTLD).

IPv6 analysis is one of the most useful outputs from this project because it helps answer questions such as:

* Are organisations deploying IPv6?
* How many domains are reachable over IPv6?
* Is IPv6 deployment driven by local operators or global cloud providers?
* Are locally hosted services supporting IPv6?
* How mature is the Internet ecosystem?

This chapter explains how to calculate IPv6 adoption statistics using the DNS data collected in the previous chapter.



# Learning Objectives

By the end of this chapter you will be able to:

* Identify IPv6-enabled domains.
* Count IPv6 records.
* Calculate IPv6 adoption percentages.
* Understand the difference between IPv6-enabled domains and IPv6-enabled services.
* Identify common sources of bias in IPv6 measurements.
* Produce IPv6 statistics suitable for reports and articles.



# What is IPv6?

IPv6 stands for:

> Internet Protocol Version 6

It is the successor to Internet Protocol Version 4 (IPv4).

IPv4 uses 32-bit addresses such as:

```text
203.0.113.20
```

IPv6 uses 128-bit addresses such as:

```text
2001:db8:100::20
```

The larger address space allows the Internet to continue growing without the limitations of IPv4 exhaustion.



# Why Measure IPv6?

IPv6 deployment is often considered an indicator of Internet ecosystem maturity.

Benefits include:

* Larger address space
* Simplified network design
* Improved scalability
* Reduced dependence on Network Address Translation (NAT)

Many governments, regulators, network operators, and Internet organisations track IPv6 deployment as part of broader Internet development initiatives.



# What Does IPv6 Adoption Mean?

There are several ways to measure IPv6 adoption.

For this project, we focus on:

> The percentage of domains that publish an AAAA record.

This is a useful indicator because it shows whether a service can potentially be reached using IPv6.



# Understanding AAAA Records

An AAAA record maps a domain name to an IPv6 address.

Example:

```text
service.example.ws
        ↓
2001:db8:100::20
```

A domain with an AAAA record is considered:

> IPv6-enabled

for the purposes of this analysis.



# Review the DNS Dataset

The previous chapter created:

```text
ws-resolved.csv
```

Example:

```csv
domain,record_type,ip_address
service1.example.ws,A,203.0.113.20
service1.example.ws,AAAA,2001:db8:100::20
service2.example.ws,A,198.51.100.20
```

This file contains:

* Domain names
* DNS record types
* IP addresses



# Count Domains with IPv6

Extract domains that publish AAAA records:

```bash
awk -F, '$2=="AAAA" {print $1}' ws-resolved.csv |
sort -u |
wc -l
```

Example output:

```text
188
```



# What Does This Command Do?

| Command      | Purpose                  |
| ------------ | ------------------------ |
| `awk -F,`    | Process a CSV file       |
| `$2=="AAAA"` | Select only AAAA records |
| `{print $1}` | Print the domain name    |
| `sort -u`    | Remove duplicates        |
| `wc -l`      | Count domains            |

The result represents:

> The number of unique domains publishing IPv6 addresses.



# Count All Resolved Domains

Count every unique domain that successfully resolved:

```bash
tail -n +2 ws-resolved.csv |
cut -d, -f1 |
sort -u |
wc -l
```

Example:

```text
458
```



# Calculate the IPv6 Adoption Rate

Store the values:

```bash
ipv6=$(awk -F, '$2=="AAAA" {print $1}' ws-resolved.csv | sort -u | wc -l)

total=$(tail -n +2 ws-resolved.csv | cut -d, -f1 | sort -u | wc -l)
```

Calculate the percentage:

```bash
echo "scale=2; $ipv6*100/$total" | bc
```

Example:

```text
41.04
```

This indicates:

> Approximately 41.04% of resolved domains publish IPv6 addresses.



# Create an IPv6 Summary File

Create a simple report:

```bash
ipv6=$(awk -F, '$2=="AAAA" {print $1}' ws-resolved.csv | sort -u | wc -l)

total=$(tail -n +2 ws-resolved.csv | cut -d, -f1 | sort -u | wc -l)

rate=$(echo "scale=2; $ipv6*100/$total" | bc)

cat << EOF > ws-ipv6-summary.txt
Domains analysed: $total
Domains with IPv6: $ipv6
IPv6 adoption rate: $rate%
EOF
```

View the report:

```bash
cat ws-ipv6-summary.txt
```

Example:

```text
Domains analysed: 458
Domains with IPv6: 188
IPv6 adoption rate: 41.04%
```



# Count IPv4 and IPv6 Addresses

The DNS dataset may contain multiple addresses per domain.

Count IPv4 addresses:

```bash
grep -vc ':' ips.txt
```

Example:

```text
373
```

Count IPv6 addresses:

```bash
grep -c ':' ips.txt
```

Example:

```text
212
```

These values describe addresses, not domains.



# Understanding the Difference

It is important to distinguish between:

## IPv6-Enabled Domains

Example:

```text
188
```

Domains with AAAA records.



## IPv6 Addresses

Example:

```text
212
```

Unique IPv6 addresses observed.



A single domain may have:

```text
service.example.ws
```

with multiple IPv6 addresses.

Therefore:

```text
Domains ≠ Addresses
```

These metrics answer different questions.



# A Common Measurement Trap

At first glance, a result such as:

```text
41.04% IPv6 adoption
```

may appear to indicate:

> 41% of organisations actively deployed IPv6.

However, that conclusion may not be correct.



# Cloud Providers Can Influence the Result

Many cloud providers automatically enable IPv6.

Examples include:

* Cloudflare
* Google
* Fastly
* Akamai
* Amazon CloudFront

If a domain is hosted behind one of these providers, it may automatically receive:

* IPv4 connectivity
* IPv6 connectivity

even if the organisation itself did not actively deploy IPv6.



# Example

Consider:

```text
service.example.ws
```

hosted behind a CDN.

The organisation may simply enable:

```text
Use CDN
```

and immediately receive:

* IPv4
* IPv6
* DDoS protection
* Global caching

The resulting AAAA record does not necessarily indicate that the organisation operates native IPv6 infrastructure.



# Local Hosting vs Cloud Hosting

A more nuanced question is:

> Who is actually providing the IPv6 connectivity?

Possible answers include:

| Scenario               | IPv6 Provider            |
| ---------------------- | ------------------------ |
| Locally hosted website | Local ISP                |
| Cloud-hosted website   | Cloud provider           |
| CDN-hosted website     | CDN provider             |
| Hybrid architecture    | Combination of providers |

This distinction becomes clearer during ASN analysis.



# Example Interpretation

Suppose analysis shows:

| Metric               | Value  |
| -------------------- | ------ |
| Domains analysed     | 458    |
| IPv6-enabled domains | 188    |
| IPv6 adoption rate   | 41.04% |

This allows us to say:

> Approximately 41% of analysed domains published IPv6 addresses.

A stronger claim such as:

> 41% of organisations have deployed IPv6

would require additional evidence.



# Additional Investigation

Later chapters will allow us to determine:

* Which Autonomous Systems announce the IPv6 addresses.
* Which cloud providers are involved.
* Whether IPv6 is being delivered locally or globally.
* Whether local services support IPv6.

This often produces more meaningful insights than a simple percentage alone.



# Visualising the Results

You may wish to create a summary table.

Example:

| Metric                  | Value  |
| ----------------------- | ------ |
| Domains analysed        | 458    |
| IPv6-enabled domains    | 188    |
| IPv6 adoption rate      | 41.04% |
| IPv4 addresses observed | 373    |
| IPv6 addresses observed | 212    |

This format is suitable for:

* Blog posts
* Reports
* Research papers
* Presentations



# Common Issues

## bc Not Installed

Example:

```text
bc: command not found
```

Install:

```bash
sudo apt install bc
```



## Zero IPv6 Domains

Example:

```text
0
```

Possible reasons:

* No organisations have deployed IPv6.
* The ccTLD is dominated by IPv4-only services.
* The sample size is small.



## Unexpectedly High IPv6 Adoption

Possible reasons:

* Heavy use of CDNs.
* Heavy use of cloud providers.
* Widespread automatic IPv6 enablement.

Further analysis is required before drawing conclusions.



# Security Considerations

This chapter uses previously collected DNS data.

No additional network activity is generated beyond the DNS queries already performed.

As always:

* Avoid browsing unknown domains.
* Treat all domains as potentially untrusted.
* Focus on metadata rather than content.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
ws-ipv6-summary.txt
```

Example:

```text
Domains analysed: 458
Domains with IPv6: 188
IPv6 adoption rate: 41.04%
```

This summary can be used directly in reports and articles.

---

# What Comes Next?

The next chapter maps IP addresses to Autonomous System Numbers (ASNs).

You will learn how to determine:

* Who hosts the services.
* Which networks announce the IP addresses.
* Which cloud providers dominate the namespace.
* Whether content is locally hosted or globally distributed.

Continue to:

```text
docs/07-asn-analysis.md
```
