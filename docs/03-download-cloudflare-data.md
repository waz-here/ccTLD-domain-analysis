# Downloading the Cloudflare Radar Dataset

## Overview

Now that the required software has been installed, the next step is obtaining a dataset that contains popular domain names.

Throughout this repository we use the:

> Cloudflare Radar Top 1 Million Domains Dataset

This dataset provides a ranking of domains based on observed Internet activity.

By filtering the dataset for a specific country-code Top-Level Domain (ccTLD), we can identify popular domains that belong to a particular namespace.

Examples include:

| Country  | ccTLD |
| -------- | ----- |
| Samoa    | `.ws` |
| Fiji     | `.fj` |
| Vanuatu  | `.vu` |
| Tonga    | `.to` |
| Tuvalu   | `.tv` |
| Kiribati | `.ki` |



# Learning Objectives

By the end of this chapter you will be able to:

* Download the Cloudflare Radar dataset.
* Verify the file was downloaded correctly.
* Understand the structure of the dataset.
* Examine the contents of a Comma-Separated Values (CSV) file.
* Prepare the dataset for analysis.



# What is Cloudflare Radar?

Cloudflare Radar is a public Internet measurement platform operated by Cloudflare.

It provides visibility into:

* Internet traffic trends
* Security events
* Routing incidents
* Protocol adoption
* Domain popularity

One of the datasets made publicly available is the:

> Top 1 Million Domains

The dataset contains domains ranked according to observed Internet activity.

It is important to understand that:

> The dataset does not contain every registered domain name.

Instead, it provides a view of domains that are actively used and visible on the Internet.

This makes it particularly useful for identifying active services.



# What is a CSV File?

The Cloudflare Radar dataset is provided as a:

> Comma-Separated Values (CSV) file

A CSV file is a plain text file where fields are separated by commas.

Example:

```csv
example.com,1
example.net,2
example.org,3
```

In this example:

| Column | Value       |
| ------ | ----------- |
| Domain | example.com |
| Rank   | 1           |

CSV files are commonly used because they are:

* Simple
* Portable
* Human readable
* Easy to process using command-line tools



# Download the Dataset

At the time of writing, Cloudflare provides the Top 1 Million Domains dataset through a downloadable link.

Create a working directory:

```bash
mkdir ccTLD-analysis

cd ccTLD-analysis
```

Verify your current location:

```bash
pwd
```

Example:

```text
/home/user/ccTLD-analysis
```



# Download Using wget

The easiest approach is to use `wget`.

```bash
wget \
-O cloudflare-top-1m.csv \
"https://radar.cloudflare.com/charts/LargerTopDomainsTable/attachment?id=1257&top=1000000"
```

## What Does This Command Do?

| Component             | Meaning                        |
| --------------------- | ------------------------------ |
| wget                  | Download a file                |
| -O                    | Save using a specific filename |
| cloudflare-top-1m.csv | Output filename                |
| URL                   | Download source                |



# Alternative: Download Using curl

You can also use `curl`.

```bash
curl -L \
-o cloudflare-top-1m.csv \
"https://radar.cloudflare.com/charts/LargerTopDomainsTable/attachment?id=1257&top=1000000"
```

## What Does This Command Do?

| Component | Meaning          |
| --------- | ---------------- |
| curl      | Download content |
| -L        | Follow redirects |
| -o        | Output filename  |



# Verify the Download

Confirm the file exists:

```bash
ls -lh
```

Example:

```text
-rw-rw-r-- 1 user user 22M Jun 10 cloudflare-top-1m.csv
```

Your size may differ depending on the version of the dataset.



# Count the Number of Records

Count the lines in the file:

```bash
wc -l cloudflare-top-1m.csv
```

Example:

```text
1000000 cloudflare-top-1m.csv
```

## What Does This Command Do?

| Component | Meaning            |
| --------- | ------------------ |
| wc        | Word Count utility |
| -l        | Count lines        |

Because the dataset contains one domain per line, this provides an approximate record count.



# Examine the First Few Entries

Display the first ten rows:

```bash
head cloudflare-top-1m.csv
```

Example:

```text
example.com
example.net
example.org
```

The actual dataset will contain real domain names and rankings.



# Examine the Last Few Entries

Display the final ten rows:

```bash
tail cloudflare-top-1m.csv
```

This helps confirm that the download completed successfully.



# Search for a Particular ccTLD

Before extracting domains, it is useful to see whether a ccTLD appears in the dataset.

For example:

```bash
grep "\.ws$" cloudflare-top-1m.csv | head
```

Example output:

```text
service.example.ws
government.example.ws
bank.example.ws
```

The actual results will contain real domains.



# Understanding the grep Command

The command:

```bash
grep "\.ws$" cloudflare-top-1m.csv
```

contains two important symbols:

| Symbol | Meaning                |
| ------ | ---------------------- |
| .      | Match a literal period |
| $      | Match end of line      |

This ensures that:

```text
service.example.ws
```

matches, while:

```text
service.example.ws.com
```

does not.



# Estimate How Many Domains Exist for a ccTLD

Count all matching entries:

```bash
grep "\.ws$" cloudflare-top-1m.csv | wc -l
```

Example:

```text
523
```

The actual value will vary depending on the date of the dataset.

This provides a quick indication of how visible a namespace is within the Top 1 Million ranking.



# Understanding Dataset Limitations

The Cloudflare Radar dataset is extremely useful, but it is important to understand what it does not show.

| Metric | Available in Cloudflare Radar Top 1 Million Dataset? | Notes |
|----------|----------|----------|
| Popular domains |  Yes | Domains ranked by observed Internet activity |
| Active domains |  Yes | Generally represents domains that are being used |
| Frequently accessed domains |  Yes | Popular services are more likely to appear |
| Every registered domain |  No | Many registered domains never appear in the ranking |
| Domain ownership |  No | Requires WHOIS or registry data |
| Hosting location |  No | Requires DNS and IP analysis |
| DNS records |  No | Must be queried separately |
| IP addresses |  No | Must be resolved using DNS tools |

Additional analysis is required to answer those questions.

The remainder of this repository focuses on extracting and analysing that information.



# Organising Your Project Directory

At this stage your working directory should resemble:

```text
ccTLD-analysis/
│
└── cloudflare-top-1m.csv
```

Additional files created later will include:

```text
ccTLD-analysis/
│
├── cloudflare-top-1m.csv
├── ws-domains.txt
├── ws-resolved.csv
├── ws-ips.txt
├── ws-asn.txt
└── reports/
```

This structure helps keep intermediate and final outputs organised.



# Troubleshooting

## Download Fails

Verify Internet connectivity:

```bash
curl -I https://example.com
```



## File Size is Zero

Check:

```bash
ls -lh cloudflare-top-1m.csv
```

If the file size is:

```text
0 bytes
```

the download did not complete successfully.

Retry the download.



## Command Not Found

Example:

```text
wget: command not found
```

Install the package:

```bash
sudo apt install wget
```



## Unable to Reach Cloudflare

Temporary network or routing issues may occur.

Retry later or use the alternative `curl` method.



# What Comes Next?

The next chapter focuses on extracting domains belonging to a specific country-code Top-Level Domain.

You will learn how to:

* Filter the dataset.
* Identify domains belonging to a particular ccTLD.
* Count domains.
* Create reusable domain lists for later analysis.

Continue to:

```text
docs/04-extract-cctld-domains.md
```
