# Identifying Key Organisations

## Overview

In the previous chapters we analysed:

* Domain popularity
* DNS records
* IPv6 deployment
* Autonomous System Numbers (ASNs)
* Cloud providers
* Content Delivery Networks (CDNs)

However, not all domains contribute equally to a country's Internet ecosystem.

Some organisations play a particularly important role in:

* Education
* Government services
* Healthcare
* Financial services
* Media
* Research
* Digital transformation

This chapter explains how to identify these organisations and why they matter when analysing a country-code Top-Level Domain (ccTLD).



# Learning Objectives

By the end of this chapter you will be able to:

* Identify key organisations within a ccTLD.
* Categorise domains by sector.
* Understand the importance of local content.
* Identify candidates for Internet Exchange Point (IXP) participation.
* Identify opportunities for content localisation.
* Build organisation-level summaries suitable for reports and articles.



# Why Focus on Organisations?

A simple list of domains can be useful, but it does not tell us:

* Which domains provide critical services.
* Which organisations serve large numbers of users.
* Which services would benefit most from local hosting.
* Which organisations might generate significant traffic.

For example:

```text
random-example.ws
```

and

```text
government.example.ws
```

may both appear in a domain list.

However, the government service is likely to have much greater significance to citizens and Internet infrastructure planning.



# Key Sectors to Investigate

When analysing a ccTLD, focus on the following sectors.

| Sector             | Examples                                                              |
| ------------------ | --------------------------------------------------------------------- |
| Government         | Ministries, agencies, public services                                 |
| Education          | Universities, colleges, schools                                       |
| Research           | National Research and Education Networks (NRENs), research institutes |
| Healthcare         | Hospitals, health services                                            |
| Banking            | Commercial banks, payment services                                    |
| Media              | Newspapers, broadcasters, news sites                                  |
| Telecommunications | Internet Service Providers (ISPs), mobile operators                   |
| Utilities          | Electricity, water, transport                                         |
| Civil Society      | Non-government organisations and community groups                     |

These organisations often represent the most important local content providers.



# Why These Organisations Matter

The presence of locally hosted services can improve:

* Performance
* Reliability
* Resilience
* Affordability

For example:

| Service Type                          | Impact if Hosted Locally              |
| ------------------------------------- | ------------------------------------- |
| University Learning Management System | Faster access for students            |
| Government Portal                     | Improved user experience              |
| News Website                          | Reduced international bandwidth       |
| Banking Application                   | Lower latency and improved resilience |



# Creating a Candidate List

Begin by reviewing the extracted domain list.

Example:

```bash
head ws-domains.txt
```

Output:

```text
service1.example.ws
service2.example.ws
service3.example.ws
```

The goal is to identify domains that appear to belong to significant organisations.



# Manual Review

A simple approach is to search for keywords.

Examples:

```bash
grep -Ei "gov|government|ministry" ws-domains.txt
```

Government-related domains.

```bash
grep -Ei "edu|school|college|university" ws-domains.txt
```

Education-related domains.

```bash
grep -Ei "bank|finance" ws-domains.txt
```

Banking-related domains.

```bash
grep -Ei "news|media|radio|tv" ws-domains.txt
```

Media-related domains.



# Creating Sector Files

Create separate files for each category.

Government:

```bash
grep -Ei "gov|government|ministry" ws-domains.txt > government.txt
```

Education:

```bash
grep -Ei "edu|school|college|university" ws-domains.txt > education.txt
```

Media:

```bash
grep -Ei "news|media|radio|tv" ws-domains.txt > media.txt
```

Banking:

```bash
grep -Ei "bank|finance" ws-domains.txt > banking.txt
```

These files provide a starting point for further investigation.



# Why Manual Review Is Important

Keyword searches are helpful, but they are not perfect.

For example:

```text
bank.example.ws
```

is easy to classify.

However:

```text
abc123.example.ws
```

may belong to:

* A bank
* A university
* A government department
* A private business

Manual review is therefore essential.



# Investigating Important Domains

Once an organisation has been identified, perform additional DNS analysis.

Check IPv4 records:

```bash
dig +short A organisation.example.ws
```

Check IPv6 records:

```bash
dig +short AAAA organisation.example.ws
```

Check mail servers:

```bash
dig MX organisation.example.ws
```

Check nameservers:

```bash
dig NS organisation.example.ws
```

These records often reveal useful information about hosting and service providers.



# Looking Beyond the Apex Domain

A common mistake is analysing only the main domain.

For example:

```text
university.example.ws
```

may appear to be hosted in a public cloud.

However, important services may exist on subdomains.

Examples:

```text
moodle.university.example.ws
library.university.example.ws
studentportal.university.example.ws
mail.university.example.ws
```

These services may be hosted differently.



# Example: Educational Services

During the Samoa case study, analysis of university-related services revealed a mixture of hosting approaches.

Examples included:

| Service Type      | Hosting Model    |
| ----------------- | ---------------- |
| Main website      | Public cloud     |
| Learning platform | Local hosting    |
| Student portal    | Local hosting    |
| Digital library   | Local hosting    |
| Email             | Google Workspace |

This demonstrates that:

> A single organisation may use multiple hosting models simultaneously.

Analysing only the main website would have produced an incomplete picture.



# Subdomain Discovery

To identify additional services, Certificate Transparency logs can be useful.

Example:

```bash
curl -s "https://crt.sh/?q=%.example.ws&output=json" |
jq -r '.[].name_value' |
sort -u
```

Potential output:

```text
moodle.example.ws
mail.example.ws
studentportal.example.ws
library.example.ws
```



# Additional Discovery Tools

Popular tools include:

| Tool      | Purpose                         |
| --------- | ------------------------------- |
| crt.sh    | Certificate Transparency search |
| Amass     | Subdomain discovery             |
| Subfinder | Subdomain discovery             |
| dig       | DNS lookups                     |
| whois     | Registration information        |

These tools can reveal services not visible from the primary website.



# Building an Organisation Inventory

Create a spreadsheet or CSV file.

Example:

| Organisation       | Sector     | Domain                | Hosting Type | IPv6 | Notes                   |
| ------------------ | ---------- | --------------------- | ------------ | ---- | ----------------------- |
| Example University | Education  | university.example.ws | Local        | Yes  | Learning platform local |
| Example Government | Government | gov.example.ws        | Cloud        | No   | Hosted offshore         |
| Example Bank       | Banking    | bank.example.ws       | CDN          | Yes  | Behind Cloudflare       |

This becomes a valuable research asset.



# Identifying Potential IXP Participants

Organisations that host significant content locally may benefit from participation in an Internet Exchange Point.

Examples include:

* Universities
* Government agencies
* Banks
* Media organisations
* Research networks

Questions to consider:

* Is the content locally hosted?
* Does the organisation operate its own network?
* Does the organisation exchange significant traffic?
* Could traffic remain local via an IXP?



# Content Localisation Opportunities

The analysis may identify services that could benefit from local hosting.

Examples:

| Service            | Current Situation      |
| ------------------ | ---------------------- |
| University LMS     | Hosted internationally |
| Government Portal  | Hosted internationally |
| National News Site | Hosted internationally |
| Banking Service    | Hosted internationally |

Such findings may support discussions about:

* Local data centres
* CDN deployments
* IXP development
* National digital infrastructure strategies



# Suggested Research Outputs

The following tables are often useful.

## Government Services

| Organisation     | Domain            | Hosting Type |
| ---------------- | ----------------- | ------------ |
| Example Ministry | gov.example.ws    | Cloud        |
| Example Agency   | agency.example.ws | Local        |



## Education Services

| Organisation       | Domain                | Hosting Type |
| ------------------ | --------------------- | ------------ |
| Example University | university.example.ws | Hybrid       |
| Example College    | college.example.ws    | Local        |



## Media Services

| Organisation        | Domain           | Hosting Type |
| ------------------- | ---------------- | ------------ |
| Example News        | news.example.ws  | CDN          |
| Example Broadcaster | media.example.ws | Cloud        |



# Common Mistakes

## Focusing Only on the Main Website

Incorrect:

```text
university.example.ws
```

Correct:

```text
university.example.ws
moodle.university.example.ws
library.university.example.ws
studentportal.university.example.ws
```



## Assuming One Hosting Model

Incorrect:

> The organisation is hosted in the cloud.

Correct:

> Different services may use different hosting models.



## Ignoring Email Services

Email often reveals useful information.

Example:

```bash
dig MX organisation.example.ws
```

Results may show:

* Google Workspace
* Microsoft 365
* Local mail servers



# Security Considerations

Avoid:

* Logging into discovered services.
* Attempting authentication.
* Running intrusive scans.
* Downloading unknown content.

Focus on:

* Public DNS information.
* Public certificate information.
* Publicly accessible metadata.

This is generally sufficient for Internet infrastructure analysis.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
government.txt
education.txt
media.txt
banking.txt
organisation-inventory.csv
```

These files help identify the most significant organisations within the namespace.

---

# What Comes Next?

The next chapter focuses on:

* Content localisation
* Local hosting
* Cloud hosting
* Hybrid architectures

and explains how to classify services using the information collected throughout the workflow.

Continue to:

```text
docs/10-content-localisation-analysis.md
```
