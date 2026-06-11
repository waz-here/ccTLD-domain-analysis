# Content Localisation Analysis

## Overview

The previous chapters examined:

* Domain popularity
* DNS records
* IPv6 deployment
* Autonomous System Numbers (ASNs)
* Cloud providers
* Content Delivery Networks (CDNs)
* Key organisations

The next step is to determine:

> Where is the content actually hosted?

This question is central to understanding Internet development, local infrastructure utilisation, and the potential benefits of Internet Exchange Points (IXPs).

A common assumption is:

> If a website uses a country's country-code Top-Level Domain (ccTLD), then it is hosted within that country.

In reality, this is often not the case.

A website may use:

```text
organisation.example.ws
```

while being hosted in:

* Sydney
* Singapore
* Tokyo
* Los Angeles
* Frankfurt

Content localisation analysis attempts to identify where services are hosted and whether they are likely to remain local to users within the country.



# Learning Objectives

By the end of this chapter you will be able to:

* Understand content localisation.
* Distinguish between local and offshore hosting.
* Identify hybrid hosting architectures.
* Classify services by hosting model.
* Evaluate opportunities for local infrastructure development.
* Interpret DNS and ASN evidence carefully.
* Produce content localisation summaries suitable for reports and articles.



# What is Content Localisation?

Content localisation refers to hosting digital services within the country where they are primarily used.

Examples include:

* Government services
* Educational platforms
* Banking systems
* News websites
* Healthcare applications

Benefits may include:

| Benefit                | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| Lower latency          | Faster response times                                        |
| Reduced transit costs  | Less international bandwidth required                        |
| Improved resilience    | Local services remain available during international outages |
| Better user experience | Faster and more reliable access                              |
| Greater control        | Local management of critical services                        |



# Why Content Localisation Matters

Consider two scenarios.

## Scenario 1: Local Hosting

```text
User
  ↓
Local ISP
  ↓
IXP
  ↓
Local Service
```

Traffic remains within the country.

Benefits include:

* Low latency
* Reduced transit costs
* Improved resilience



## Scenario 2: Offshore Hosting

```text
User
  ↓
Local ISP
  ↓
International Transit
  ↓
Overseas Data Centre
```

Traffic must leave the country.

Benefits of a local IXP may be limited because the content itself is not local.



# Hosting Classification Framework

Throughout this repository we use the following classification model.

| Classification | Description                                          |
| -------------- | ---------------------------------------------------- |
| Local Hosting  | Service hosted within the country                    |
| Cloud Hosting  | Service hosted on a public cloud platform            |
| CDN Hosted     | Service delivered through a Content Delivery Network |
| Hybrid         | Combination of multiple hosting models               |
| Unknown        | Insufficient evidence                                |

This framework provides a practical way to categorise services.



# Sources of Evidence

Content localisation analysis relies on multiple indicators.

Examples include:

* DNS records
* ASN ownership
* MX records
* Nameserver records
* Certificate Transparency logs
* Subdomain discovery
* Traceroute measurements
* Operator knowledge

No single source is sufficient on its own.



# Why DNS Alone is Not Enough

Suppose a domain resolves to:

```text
198.51.100.20
```

and ASN analysis identifies:

```text
AS13335
Cloudflare
```

This tells us:

* Cloudflare is involved.
* The service uses Cloudflare infrastructure.

It does not tell us:

* Where the origin server is located.
* Whether the service is locally hosted.
* Whether the service is hosted internationally.

Additional investigation is required.



# Worked Example: National University of Samoa

A useful example comes from the National University of Samoa.

Initial analysis focused on the primary website:

```text
nus.edu.ws
```

DNS analysis identified:

```text
35.213.213.170
```

ASN analysis showed:

```text
AS15169
Google
```

At first glance, one might conclude:

> The National University of Samoa is hosted on Google Cloud.

While technically true for the primary website, further investigation revealed a more complex picture.



# Why the Main Website Was Misleading

Subdomain discovery identified additional services.

Examples included:

```text
moodle.nus.edu.ws
learning.nus.edu.ws
studentportal.nus.edu.ws
digitallibrary.nus.edu.ws
email.nus.edu.ws
mail.student.nus.edu.ws
```

These services used different hosting models.



# Moodle

DNS:

```text
moodle.nus.edu.ws
↓
103.131.62.20
```

ASN:

```text
AS38800
Digicel Samoa
```

Classification:

| Service    | Classification |
| ---------- | -------------- |
| Moodle LMS | Local Hosting  |

This service appears to be hosted within Samoa.



# Learning Platform

DNS:

```text
learning.nus.edu.ws
↓
103.131.62.12
```

ASN:

```text
AS38800
Digicel Samoa
```

Classification:

| Service           | Classification |
| ----------------- | -------------- |
| Learning Platform | Local Hosting  |



# Student Portal

DNS:

```text
studentportal.nus.edu.ws
↓
103.131.62.14
```

ASN:

```text
AS38800
Digicel Samoa
```

Classification:

| Service        | Classification |
| -------------- | -------------- |
| Student Portal | Local Hosting  |



# Digital Library

DNS:

```text
digitallibrary.nus.edu.ws
↓
103.131.62.15
```

ASN:

```text
AS38800
Digicel Samoa
```

Classification:

| Service         | Classification |
| --------------- | -------------- |
| Digital Library | Local Hosting  |



# Email Services

DNS analysis identified:

```text
email.nus.edu.ws
↓
202.4.40.52
```

ASN:

```text
AS17993
Vodafone Samoa
```

This suggests local hosting for part of the university's email infrastructure.

However, MX analysis revealed:

```text
student.nus.edu.ws
↓
aspmx.l.google.com
```

Further DNS analysis identified:

```text
mail.student.nus.edu.ws
↓
142.250.x.x
```

and:

```text
2404:6800:xxxx::xxxx
```

Both belonging to Google.

Classification:

| Service              | Classification   |
| -------------------- | ---------------- |
| Student Email        | Google Workspace |
| Email Infrastructure | Hybrid           |



# What Did We Learn?

The university was not using a single hosting model.

Instead, it was using:

| Service              | Hosting Model    |
| -------------------- | ---------------- |
| Main Website         | Google Cloud     |
| Moodle               | Local Hosting    |
| Learning Platform    | Local Hosting    |
| Student Portal       | Local Hosting    |
| Digital Library      | Local Hosting    |
| Student Email        | Google Workspace |
| Email Infrastructure | Hybrid           |

This is a realistic example of modern Internet infrastructure.



# Why This Matters for IXPs

Suppose a student accesses:

```text
moodle.nus.edu.ws
```

If:

* The student is connected via a local ISP.
* The service is hosted locally.
* Networks exchange traffic locally.

Then traffic may remain within Samoa.

Example:

```text
Student
  ↓
Local ISP
  ↓
IXP
  ↓
NUS Moodle
```

This can reduce:

* Latency
* Transit costs
* International bandwidth usage



# The Importance of Service-Level Analysis

If we had analysed only:

```text
nus.edu.ws
```

we would have concluded:

> NUS is hosted on Google Cloud.

This would have missed:

* Moodle
* Student portal
* Digital library
* Local learning systems

Service-level analysis often reveals a much richer picture.



# Creating a Localisation Inventory

A useful approach is to create a spreadsheet.

Example:

| Organisation | Service         | Hosting Type     | Evidence     |
| ------------ | --------------- | ---------------- | ------------ |
| University   | Website         | Cloud            | Google Cloud |
| University   | Moodle          | Local            | AS38800      |
| University   | Student Portal  | Local            | AS38800      |
| University   | Digital Library | Local            | AS38800      |
| University   | Student Email   | Google Workspace | Google MX    |

This allows findings to be documented systematically.



# Identifying Local Content Opportunities

Common candidates include:

* Universities
* Schools
* Government agencies
* Hospitals
* Media organisations
* Banks

Questions to consider:

* Is the service hosted locally?
* Could it be hosted locally?
* Would local hosting improve performance?
* Would local hosting increase resilience?



# Common Mistakes

## Analysing Only the Main Website

Incorrect:

> The organisation uses Google Cloud.

Correct:

> The organisation uses multiple hosting models.



## Assuming Cloud Hosting Means No Local Content

Incorrect:

> Everything is hosted overseas.

Correct:

> Different services may be hosted in different locations.



## Assuming Local ASN Means Local Users

A service may be locally hosted but still accessed internationally.

Local hosting and local usage are different concepts.



# Suggested Research Outputs

## Hosting Classification Summary

| Classification | Services |
| -------------- | -------- |
| Local Hosting  | 4        |
| Cloud Hosting  | 1        |
| Hybrid         | 1        |



## Organisation Summary

| Organisation       | Local Services | Cloud Services |
| ------------------ | -------------- | -------------- |
| Example University | Moodle, Portal | Website        |
| Example Government | Portal         | Email          |



## Localisation Opportunities

| Service           | Current Hosting | Opportunity   |
| ----------------- | --------------- | ------------- |
| Learning Platform | Overseas        | Local Hosting |
| News Website      | Overseas        | Local Hosting |
| Government Portal | Overseas        | Local Hosting |



# Limitations

This methodology provides evidence, not certainty.

Challenges include:

* CDN masking
* Cloud abstractions
* Hidden origin servers
* Anycast routing
* Multi-cloud architectures

The goal is to develop a reasonable understanding of hosting patterns rather than prove the exact physical location of every service.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
localisation-inventory.csv
```

containing:

* Organisation
* Service
* Hosting classification
* Supporting evidence

This becomes one of the most valuable outputs of the entire workflow.

---

# What Comes Next?

The next chapter focuses on:

* Security considerations
* Domain reputation analysis
* Malware risks
* Safe investigation techniques

This is particularly important when analysing large numbers of unknown domains.

Continue to:

```text
docs/11-security-and-reputation-analysis.md
```
