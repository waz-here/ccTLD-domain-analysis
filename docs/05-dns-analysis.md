# DNS Analysis

## Overview

After extracting the domains belonging to a country-code Top-Level Domain (ccTLD), the next step is to determine whether those domains are active and identify the Internet Protocol (IP) addresses associated with them.

This process is performed using the Domain Name System (DNS).

DNS analysis allows us to:

* Identify active domains.
* Discover IPv4 addresses.
* Discover IPv6 addresses.
* Measure IPv6 adoption.
* Prepare data for Autonomous System Number (ASN) analysis.
* Investigate hosting providers and Content Delivery Networks (CDNs).

In this chapter we will create a file containing:

```text
domain,record_type,ip_address
```

Example:

```csv
service.example.ws,A,203.0.113.20
service.example.ws,AAAA,2001:db8:100::20
```



# Learning Objectives

By the end of this chapter you will be able to:

* Query DNS records using `dig`.
* Understand A and AAAA records.
* Resolve domains to IP addresses.
* Create a reusable CSV dataset.
* Count active domains.
* Identify domains that do not resolve.
* Prepare data for IPv6 and ASN analysis.



# What is DNS?

The Domain Name System (DNS) translates human-readable domain names into IP addresses.

For example:

```text
service.example.ws
        ↓
203.0.113.20
```

Without DNS, users would need to remember numeric IP addresses rather than domain names.



# Understanding A Records

An A record maps a domain name to an IPv4 address.

Example:

```text
service.example.ws
        ↓
203.0.113.20
```

When a user visits the website, DNS returns the IPv4 address.



# Understanding AAAA Records

An AAAA record maps a domain name to an IPv6 address.

Example:

```text
service.example.ws
        ↓
2001:db8:100::20
```

A domain may have:

| Configuration | Description             |
| ------------- | ----------------------- |
| A only        | IPv4 only               |
| AAAA only     | IPv6 only               |
| A and AAAA    | Dual-stack              |
| Neither       | Not publicly resolvable |

Most public services currently operate using both A and AAAA records.



# Why Collect Both A and AAAA Records?

Later chapters will:

* Measure IPv6 adoption.
* Determine hosting providers.
* Identify Autonomous Systems.
* Investigate content localisation.

Collecting both record types now avoids repeating DNS queries later.



# Inspect a Single Domain

Before automating the process, test a single domain.

## Query IPv4

```bash
dig A example.com
```

To display only the address:

```bash
dig +short A example.com
```

Example:

```text
192.0.2.20
```



## Query IPv6

```bash
dig AAAA example.com
```

To display only the address:

```bash
dig +short AAAA example.com
```

Example:

```text
2001:db8:100::20
```



# Understanding +short

The `+short` option removes most DNS metadata.

Without:

```bash
dig A example.com
```

Output may contain:

* Query information
* Resolver information
* Flags
* Authority sections

With:

```bash
dig +short A example.com
```

Only the IP address is returned.

Example:

```text
203.0.113.20
```

This makes automation much easier.



# Create the Output File

Suppose you have:

```text
ws-domains.txt
```

containing:

```text
service1.example.ws
service2.example.ws
service3.example.ws
```

Create a CSV file:

```bash
echo "domain,record_type,ip_address" > ws-resolved.csv
```

Verify:

```bash
cat ws-resolved.csv
```

Output:

```csv
domain,record_type,ip_address
```



# Resolve IPv4 and IPv6 Records

Use the following loop:

```bash
while read domain
do
    dig +short A "$domain" |
    while read ip
    do
        echo "$domain,A,$ip"
    done

    dig +short AAAA "$domain" |
    while read ip
    do
        echo "$domain,AAAA,$ip"
    done

done < ws-domains.txt >> ws-resolved.csv
```

This may take several minutes depending on:

* Number of domains
* DNS response times
* Internet connectivity



# What Does This Script Do?

## Read Each Domain

```bash
while read domain
```

Reads one domain at a time from:

```text
ws-domains.txt
```



## Query IPv4 Records

```bash
dig +short A "$domain"
```

Returns any IPv4 addresses.

Example:

```text
203.0.113.20
```



## Query IPv6 Records

```bash
dig +short AAAA "$domain"
```

Returns any IPv6 addresses.

Example:

```text
2001:db8:100::20
```



## Write CSV Output

Each result is written as:

```csv
service.example.ws,A,203.0.113.20
```

or:

```csv
service.example.ws,AAAA,2001:db8:100::20
```



# View the Results

Display the first few rows:

```bash
head ws-resolved.csv
```

Example:

```csv
domain,record_type,ip_address
service1.example.ws,A,203.0.113.20
service1.example.ws,AAAA,2001:db8:100::20
service2.example.ws,A,198.51.100.20
```



# Count Total DNS Records

Count all rows:

```bash
wc -l ws-resolved.csv
```

Remember:

* The first row is the header.
* Remaining rows are DNS records.



# Count Active Domains

Count unique domains that resolved:

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



# Understanding the Command

| Command     | Purpose               |
| ----------- | --------------------- |
| tail -n +2  | Skip header row       |
| cut -d, -f1 | Extract domain column |
| sort -u     | Remove duplicates     |
| wc -l       | Count domains         |



# Count IPv4 Records

```bash
awk -F, '$2=="A"' ws-resolved.csv | wc -l
```

Example:

```text
373
```



# Count IPv6 Records

```bash
awk -F, '$2=="AAAA"' ws-resolved.csv | wc -l
```

Example:

```text
212
```



# Identify Domains with IPv6

Count unique domains that publish AAAA records:

```bash
awk -F, '$2=="AAAA" {print $1}' ws-resolved.csv |
sort -u |
wc -l
```

Example:

```text
188
```

This metric becomes important in the IPv6 analysis chapter.



# Extract Unique IP Addresses

Create a file containing unique addresses:

```bash
tail -n +2 ws-resolved.csv |
cut -d, -f3 |
sort -u > ips.txt
```

View the first few entries:

```bash
head ips.txt
```

Example:

```text
198.51.100.20
198.51.100.21
2001:db8:100::20
```



# Why Create ips.txt?

The ASN analysis chapter maps IP addresses to:

* Network operators
* Hosting providers
* Countries
* Autonomous Systems

Using unique IP addresses reduces the number of queries required.



# Detect IPv4 and IPv6 Addresses

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



# Common DNS Resolution Issues

## Domain Does Not Resolve

Example:

```bash
dig +short A service.example.ws
```

returns:

```text
(no output)
```

Possible reasons:

* Domain no longer exists.
* DNS misconfiguration.
* Service is offline.
* IPv6-only service.



## DNS Timeout

Example:

```text
communications error
timed out
```

Check:

```bash
resolvectl status
```

to verify DNS configuration.



## Slow Queries

Large datasets may contain hundreds or thousands of domains.

Resolution can take several minutes.

You may wish to:

* Run overnight.
* Use a local recursive resolver.
* Cache results.

---

# Optional: Faster DNS Resolution with Parallel Processing

The earlier DNS resolution loop is intentionally simple and beginner-friendly.

However, if your domain list contains hundreds or thousands of domains, resolving them one at a time can be slow.

Parallel processing allows multiple DNS lookups to run at the same time.

> [!TIP]
> Start with the simple loop first. Use parallel processing only after you understand the basic workflow.


## Option 1: Use xargs

`xargs` is commonly installed by default on Ubuntu.

Create a new output file:

```bash
echo "domain,record_type,ip_address" > ws-resolved.csv
```

Run parallel DNS lookups:

```bash
cat ws-domains.txt |
xargs -P 10 -I {} sh -c '
    domain="$1"

    dig +short A "$domain" |
    while read ip
    do
        echo "$domain,A,$ip"
    done

    dig +short AAAA "$domain" |
    while read ip
    do
        echo "$domain,AAAA,$ip"
    done
' sh {} >> ws-resolved.csv
```



## What Does This Command Do?

| Component            | Meaning                           |
| -------------------- | --------------------------------- |
| `cat ws-domains.txt` | Read the list of domains          |
| `xargs`              | Build and run commands from input |
| `-P 10`              | Run up to 10 lookups in parallel  |
| `-I {}`              | Replace `{}` with each domain     |
| `sh -c`              | Run a small shell script          |
| `dig +short A`       | Query IPv4 records                |
| `dig +short AAAA`    | Query IPv6 records                |
| `>> ws-resolved.csv` | Append results to the CSV file    |



## Choosing a Parallelism Value

The value:

```bash
-P 10
```

means:

> Run up to 10 DNS lookup jobs at the same time.

For small datasets, this is usually safe.

Suggested starting values:

| Dataset Size            | Suggested `-P` Value |
| ----------------------- | -------------------- |
| Fewer than 500 domains  | `-P 5`               |
| 500–5,000 domains       | `-P 10`              |
| More than 5,000 domains | `-P 20`              |

Avoid very high values such as:

```bash
-P 100
```

because they may:

* Overload your resolver.
* Trigger rate limiting.
* Produce unreliable results.
* Generate unnecessary DNS traffic.



## Sort the Output

Because parallel jobs finish in different orders, the output may not follow the same order as the input file.

Sort the results:

```bash
(head -n 1 ws-resolved.csv && tail -n +2 ws-resolved.csv | sort -u) > ws-resolved-sorted.csv
```

Replace the original file:

```bash
mv ws-resolved-sorted.csv ws-resolved.csv
```



## Option 2: Use GNU parallel

GNU `parallel` is more powerful than `xargs`, but it may not be installed by default.

Install it:

```bash
sudo apt install parallel
```

Create a small helper function:

```bash
resolve_domain() {
    domain="$1"

    dig +short A "$domain" |
    while read ip
    do
        echo "$domain,A,$ip"
    done

    dig +short AAAA "$domain" |
    while read ip
    do
        echo "$domain,AAAA,$ip"
    done
}

export -f resolve_domain
```

Run the lookups:

```bash
echo "domain,record_type,ip_address" > ws-resolved.csv

parallel -j 10 resolve_domain :::: ws-domains.txt >> ws-resolved.csv
```



## What Does GNU parallel Do?

| Component             | Meaning                  |
| --------------------- | ------------------------ |
| `parallel`            | Run commands in parallel |
| `-j 10`               | Run 10 jobs at once      |
| `resolve_domain`      | Function to run          |
| `:::: ws-domains.txt` | Read input from the file |



## When Should You Use Parallel Processing?

Use parallel processing when:

* You have a large list of domains.
* Serial DNS lookups are taking too long.
* You are using a reliable resolver.
* You understand the basic workflow.

Avoid parallel processing when:

* You are learning the workflow for the first time.
* Your Internet connection is unstable.
* You are using a shared or fragile DNS resolver.
* You are analysing a very small dataset.


## Important Notes

> [!WARNING]
> Parallel DNS lookups create more traffic than serial lookups.

Use reasonable limits and avoid unnecessary repeated queries.

For most country-code Top-Level Domain analysis using the Cloudflare Radar Top 1 Million dataset, `-P 10` or `-j 10` is usually enough.

> [!IMPORTANT]
> Parallel processing may change the order of results.
>
> This does not affect the analysis, but it is a good idea to sort and deduplicate the output before continuing.

---

# Security Considerations

DNS resolution is generally considered low risk because:

* No web content is retrieved.
* No scripts are executed.
* No files are downloaded.

However:

* Avoid visiting unknown domains in a web browser.
* Do not assume a domain is trustworthy because it resolves.
* Treat all domains as potentially hostile until verified.

Further security guidance is provided later in the repository.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
ws-domains.txt
ws-resolved.csv
ips.txt
```

Example:

```text
ccTLD-analysis/
│
├── ws-domains.txt
├── ws-resolved.csv
└── ips.txt
```

These files form the foundation for the remaining analysis.

---

# What Comes Next?

The next chapter uses the DNS data collected here to measure IPv6 adoption within the selected ccTLD.

You will learn how to calculate:

* Number of IPv6-enabled domains.
* Percentage of IPv6 adoption.
* Differences between local hosting and cloud-hosted services.

Continue to:

```text
docs/06-ipv6-analysis.md
```
