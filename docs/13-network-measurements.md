# Measuring Network Paths with MTR

## Overview

DNS records, IP addresses, Autonomous System Numbers (ASNs), and hosting providers provide valuable insights into where content is hosted. However, they do not show how users actually reach that content.

A website may appear to be hosted locally, but traffic could still traverse international links due to routing policies, CDN architectures, or the absence of local interconnection.

Network path measurements help answer questions such as:

- Does traffic remain within the country?
- Is traffic exchanged at a local IXP?
- Which transit providers are involved?
- How many network hops are required to reach the destination?
- What latency do users experience?
- Is there evidence of packet loss or congestion?

One of the most widely used tools for this purpose is MTR (My Traceroute).

---

## What is MTR?

MTR combines the functionality of:

- ping
- traceroute

Unlike traceroute, which provides a single snapshot of the network path, MTR continuously probes each hop and collects statistics over time.

This provides a more reliable view of:

- Network latency
- Packet loss
- Route stability
- Jitter
- End-to-end path characteristics

---

## Installing MTR

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install mtr
```

### RHEL/CentOS/Rocky Linux

```bash
sudo dnf install mtr
```

### macOS

```bash
brew install mtr
```

---

## Understanding the Results

Typical fields include:

| Field | Description |
|---------|---------|
| Loss% | Percentage of probes not answered |
| Last | Most recent latency measurement |
| Avg | Average latency |
| Best | Lowest observed latency |
| Wrst | Highest observed latency |
| StDev | Variation in latency |

### Packet Loss

Packet loss at an intermediate hop does not always indicate a problem.

Many routers intentionally rate-limit ICMP responses for security reasons.

Example:

```text
Hop 5      60% loss
Hop 6       0% loss
Hop 7       0% loss
Destination 0% loss
```

In this case, the router at Hop 5 is likely rate-limiting responses rather than dropping traffic.

---

## Preferred Interactive Commands

These commands provide a useful balance between readability and technical detail when investigating a path in real time.

### Interactive ASN View

```bash
mtr -wzt example.com
```

Options used:

| Option | Description |
|---------|---------|
| -w | Wide display format |
| -z | Show ASN information |
| -t | Terminal interactive interface |

This command displays:

- Hostnames
- ASN information
- Packet loss
- Latency statistics
- Real-time updates

Suitable for:

- Identifying transit providers
- Understanding routing paths
- Demonstrating CDN locations
- Exploratory measurements

### Interactive ASN View with Numeric Addresses

```bash
mtr -wztn example.com
```

Options used:

| Option | Description |
|---------|---------|
| -w | Wide display format |
| -z | Show ASN information |
| -t | Terminal interactive interface |
| -n | Disable reverse DNS lookups |

This command displays IP addresses instead of hostnames.

Advantages:

- Faster startup
- Avoids reverse DNS delays
- Prevents misleading hostname information
- Produces cleaner output for analysis
- Useful when measuring large numbers of domains

For research and documentation, many operators prefer:

```bash
mtr -wztn example.com
```

because raw IP addresses combined with ASN information are often easier to verify using WHOIS, PeeringDB, and routing databases.

---

## Report Mode

### Generate a Report

```bash
mtr -r example.com
```

### 100 Probe Report

```bash
mtr -rwznc 100 example.com
```

Options used:

| Option | Description |
|---------|---------|
| -r | Report mode |
| -w | Wide output |
| -z | Show ASN information |
| -n | Numeric addresses |
| -c 100 | Send 100 probes |

This is ideal for:

- Blog posts
- Research reports
- Repeatable measurements
- Evidence collection

---

## Measuring Real Web Traffic

Many websites prioritise TCP traffic over ICMP.

To simulate normal web traffic:

```bash
mtr -rwznc 100 --tcp --port 443 example.com
```

Useful for:

- Websites
- Government portals
- CDNs
- Cloud-hosted applications

---

## IPv4 and IPv6 Testing

### IPv4

```bash
mtr -4 example.com
```

### IPv6

```bash
mtr -6 example.com
```

IPv4 and IPv6 frequently follow different paths and may use different transit providers or CDN locations.

---

## Applying MTR to ccTLD Analysis

MTR complements DNS, ASN, CDN, and hosting analysis by showing the actual path taken by traffic.

Suggested workflow:

1. Identify domains of interest.
2. Resolve IP addresses.
3. Determine the ASN.
4. Perform MTR measurements.
5. Compare latency and path characteristics.
6. Classify services as local, regional, or offshore.

Example:

| Domain | ASN | Avg RTT | Hop Count | Observation |
|---------|---------|---------|---------|---------|
| moodle.nus.edu.ws | AS38800 | 5 ms | 4 | Local |
| businessregistries.gov.ws | AS16509 | 90 ms | 10 | Offshore |
| samoaobserver.ws | AS13335 | 65 ms | 8 | Cloudflare CDN |

---

## Supporting Evidence for SamIXP Research

MTR measurements can help determine:

- Whether traffic remains within Samoa
- Whether traffic appears to traverse SamIXP
- Which transit providers are involved
- Whether content is served locally or offshore
- Whether CDN caches are likely local, regional, or international

When combined with DNS, ASN, CDN, and hosting analysis, MTR provides a practical view of how users actually reach online services.

---

## Limitations

MTR should not be used in isolation.

### ICMP Filtering

Some networks deprioritise or block ICMP traffic.

TCP-based measurements may provide more representative results.

### Hidden Hops

Some routers suppress responses.

Missing hops do not necessarily indicate a network problem.

### Reverse DNS Inaccuracies

Hostnames do not always accurately represent physical locations.

Additional evidence should be gathered from:

- WHOIS
- PeeringDB
- Looking Glass servers
- Operator documentation

### Single Vantage Point

Measurements from one network provide only one perspective.

Where possible, collect measurements from:

- Multiple ISPs
- Multiple locations
- Local and international vantage points

---

## Further Reading

- https://www.bitwizard.nl/mtr/
- https://github.com/traviscross/mtr
- https://atlas.ripe.net/
- https://www.caida.org/projects/ark/
