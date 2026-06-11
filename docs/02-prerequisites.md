# Prerequisites

Before analysing a country-code Top-Level Domain (ccTLD), a small number of tools must be installed.

This guide has been tested on:

* Ubuntu 22.04 LTS
* Ubuntu 24.04 LTS

Most commands will also work on other Linux distributions, but only Ubuntu is covered in this repository.



# Learning Objectives

By the end of this chapter you will be able to:

* Install the required software packages.
* Verify the tools are working correctly.
* Understand the purpose of each tool.
* Prepare an Ubuntu system for DNS, Autonomous System Number (ASN), and Internet infrastructure analysis.



# Why Are Additional Tools Required?

The analysis performed in this repository relies on information from:

* Domain Name System (DNS) records
* Internet Protocol (IP) addresses
* Autonomous System Numbers (ASNs)
* Hosting providers
* Public Internet measurement datasets

Ubuntu includes some useful networking tools by default, but several additional packages are required.



# Required Software

The following tools are used throughout this repository.

| Tool  | Package        | Purpose                                            |
| ----- | -------------- | -------------------------------------------------- |
| dig   | dnsutils       | Query DNS records                                  |
| whois | whois          | Query ownership and registration information       |
| curl  | curl           | Download files and retrieve web content            |
| jq    | jq             | Process JavaScript Object Notation (JSON) data     |
| nc    | netcat-openbsd | Query Team Cymru ASN services                      |
| wget  | wget           | Download files from websites                       |
| awk   | gawk           | Process text and comma-separated value (CSV) files |
| sort  | coreutils      | Sort data                                          |
| uniq  | coreutils      | Remove duplicate entries                           |
| wc    | coreutils      | Count lines and records                            |

Most of these tools are small, lightweight, and widely used throughout the Linux ecosystem.



# Update Ubuntu

Before installing any packages, update the local package index.

```bash
sudo apt update
```

Example output:

```text
Hit:1 http://archive.ubuntu.com/ubuntu noble InRelease
Reading package lists... Done
```

## What Does This Command Do?

| Component | Meaning                                        |
| --------- | ---------------------------------------------- |
| sudo      | Run the command with administrative privileges |
| apt       | Ubuntu package management tool                 |
| update    | Download the latest package information        |

This command does **not** upgrade software.

It only refreshes Ubuntu's list of available packages.



# Install Required Packages

Install all required software:

```bash
sudo apt install -y \
dnsutils \
whois \
curl \
jq \
wget \
netcat-openbsd
```

Example output:

```text
The following NEW packages will be installed:
dnsutils whois curl jq wget netcat-openbsd
```



# Package Explanations

## dnsutils

The `dnsutils` package provides the `dig` command.

`dig` stands for:

> Domain Information Groper

It is one of the most important tools used throughout this repository.

Example:

```bash
dig example.com
```

This queries DNS and returns information about the domain.

Later exercises use `dig` extensively to identify:

* IPv4 addresses
* IPv6 addresses
* Mail servers
* Nameservers



## whois

The `whois` package allows queries against registration and ownership databases.

Example:

```bash
whois example.com
```

The tool is also useful for investigating Internet resources such as:

* IP addresses
* ASNs
* Domain registrations



## curl

`curl` is used to retrieve content from websites and Application Programming Interfaces (APIs).

Example:

```bash
curl https://example.com
```

The tool is particularly useful when:

* Downloading data
* Querying web services
* Investigating HTTP headers



## jq

Many Internet services return data in JavaScript Object Notation (JSON) format.

`jq` allows JSON data to be searched and processed.

Example:

```bash
curl https://example.com/data.json | jq
```

Later exercises use `jq` to process:

* Certificate Transparency logs
* JSON APIs
* Domain discovery results



## wget

`wget` is used to download files.

Example:

```bash
wget https://example.com/file.csv
```

Throughout this repository, `wget` is used to download:

* Cloudflare Radar datasets
* Supporting files
* Research data



## netcat

`netcat` is often called:

> The Swiss Army Knife of Networking

In this repository it is used primarily to query:

* Team Cymru's IP-to-ASN mapping service

Example:

```bash
nc whois.cymru.com 43
```

This allows IP addresses to be mapped to:

* Autonomous Systems
* Network operators
* Countries



# Verify the Installation

Check that each tool is available.

## dig

```bash
dig -v
```

Example:

```text
DiG 9.18.x
```



## whois

```bash
whois --version
```

Example:

```text
Version 5.x.x
```



## curl

```bash
curl --version
```

Example:

```text
curl 8.x.x
```



## jq

```bash
jq --version
```

Example:

```text
jq-1.7
```



## wget

```bash
wget --version
```

Example:

```text
GNU Wget 1.21.x
```



## netcat

```bash
nc -h
```

Example:

```text
OpenBSD netcat
```



# Verify DNS Resolution

Before continuing, confirm DNS is working correctly.

Run:

```bash
dig example.com +short
```

Expected output:

```text
93.184.216.34
```

Your result may differ.

The important thing is that an IP address is returned.



# Verify Internet Connectivity

Confirm your system can access external websites.

```bash
curl -I https://example.com
```

Expected output:

```text
HTTP/2 200
```

or:

```text
HTTP/2 301
```

This confirms:

* DNS is functioning.
* HTTPS connectivity is working.
* External services are reachable.



# Troubleshooting

## Command Not Found

Example:

```text
dig: command not found
```

Solution:

```bash
sudo apt install dnsutils
```



## Permission Denied

Example:

```text
Permission denied
```

Solution:

Ensure the command is being executed with:

```bash
sudo
```

when administrative access is required.



## DNS Queries Fail

Example:

```text
connection timed out
```

Check:

```bash
resolvectl status
```

This displays:

* DNS servers
* Resolver configuration
* Current DNS status



## Package Installation Fails

Refresh package information:

```bash
sudo apt update
```

Then retry the installation.



# What Comes Next?

Now that the required tools are installed, the next step is obtaining the Cloudflare Radar Top 1 Million Domains dataset.

The following chapter explains:

* What the dataset contains
* Why it is useful
* How to download it
* How to inspect the contents

Continue to [03-download-cloudflare-data.md](03-download-cloudflare-data.md)

