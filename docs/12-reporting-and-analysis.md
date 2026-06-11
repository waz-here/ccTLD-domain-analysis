# Reporting and Analysis

## Overview

Throughout this repository we have collected and analysed:

* Popular domains
* DNS records
* IPv6 deployment
* Autonomous System Numbers (ASNs)
* Cloud providers
* Content Delivery Networks (CDNs)
* Key organisations
* Content localisation indicators
* Security and reputation information

This chapter explains how to transform those technical findings into meaningful observations and recommendations.

The goal is not simply to produce statistics.

The goal is to answer questions such as:

* How mature is the local Internet ecosystem?
* Is content hosted locally?
* Is IPv6 being adopted?
* Which cloud providers dominate?
* Are there opportunities for content localisation?
* Could an Internet Exchange Point (IXP) create value?



# Learning Objectives

By the end of this chapter you will be able to:

* Create summary statistics.
* Develop evidence-based observations.
* Identify meaningful trends.
* Produce tables suitable for reports and presentations.
* Explain technical findings to non-technical audiences.
* Avoid common interpretation mistakes.



# Turning Data into Insights

Many measurement projects fail because they stop at:

```text
41.04% IPv6 adoption
```

or

```text
AS13335 = 364 IP addresses
```

These figures are useful, but they do not explain:

> Why the result matters.

A good report focuses on interpretation rather than raw numbers.



# Building a Summary Table

Start with a simple summary.

Example:

| Metric                 | Value                |
| ---------------------- | -------------------- |
| Domains analysed       | 458                  |
| Unique IP addresses    | 586                  |
| IPv6-enabled domains   | 188                  |
| IPv6 adoption rate     | 41.04%               |
| Most common ASN        | AS13335 (Cloudflare) |
| Second most common ASN | AS16509 (AWS)        |

This provides a high-level overview.



# Reporting IPv6 Results

A common mistake is writing:

> 41% of organisations have deployed IPv6.

The data does not prove this.

A more accurate statement is:

> Approximately 41% of analysed domains published AAAA records and were reachable over IPv6.

This distinction is important because many domains inherit IPv6 capability from:

* Cloud providers
* Content Delivery Networks
* Managed hosting platforms

rather than through deliberate IPv6 deployment by the organisation.



# Reporting CDN Usage

Suppose ASN analysis shows:

| ASN     | Count |
| ------- | ----- |
| AS13335 | 364   |
| AS16509 | 44    |
| AS63949 | 26    |

A poor conclusion would be:

> Most content is hosted by Cloudflare.

The data does not support this.

A more accurate conclusion is:

> Cloudflare infrastructure represented the largest proportion of observed IP addresses, indicating significant use of CDN and reverse proxy services.

This acknowledges the role of Cloudflare without making assumptions about origin hosting.



# Reporting Cloud Usage

Cloud-hosted services may indicate:

* Modernisation
* Outsourcing
* Limited local hosting options
* Desire for global reach

Example:

> Several organisations appear to use public cloud infrastructure, including Amazon Web Services and Google Cloud, suggesting reliance on internationally hosted platforms.



# Reporting Local Hosting

Local hosting is often one of the most interesting findings.

Example:

> Several educational services were hosted on local network infrastructure, indicating that some content and services are already positioned to benefit from local traffic exchange.

This is generally more meaningful than simply listing IP addresses.



# Worked Example: National University of Samoa

The National University of Samoa analysis demonstrated a hybrid hosting model.

Summary:

| Service           | Hosting Model    |
| ----------------- | ---------------- |
| Main Website      | Google Cloud     |
| Moodle LMS        | Local Hosting    |
| Learning Platform | Local Hosting    |
| Student Portal    | Local Hosting    |
| Digital Library   | Local Hosting    |
| Student Email     | Google Workspace |

Possible interpretation:

> While the university's primary website was hosted on cloud infrastructure, several critical educational services were hosted locally. This suggests that a significant proportion of educational traffic could potentially remain within Samoa if local traffic exchange arrangements exist.

Notice that this statement focuses on:

* Outcomes
* User impact
* Infrastructure implications

rather than technology alone.



# Looking for Patterns

Good analysis identifies recurring themes.

Examples:

## Theme: Heavy CDN Usage

Evidence:

* Large proportion of AS13335 addresses.
* Many domains resolving to Cloudflare.

Possible interpretation:

> CDN adoption appears widespread, likely improving performance and resilience for many services.



## Theme: Limited Local Hosting

Evidence:

* Most services hosted on international cloud providers.
* Few local ASNs represented.

Possible interpretation:

> Opportunities may exist to encourage local hosting and content localisation.



## Theme: Strong Educational Presence

Evidence:

* Multiple educational institutions identified.
* Locally hosted learning platforms.

Possible interpretation:

> Educational services may represent an important source of locally exchangeable traffic.



# Identifying Content Localisation Opportunities

One useful reporting output is:

| Service            | Current Hosting     | Potential Opportunity |
| ------------------ | ------------------- | --------------------- |
| Government Portal  | International Cloud | Local Hosting         |
| National News Site | International Cloud | Local CDN Cache       |
| University LMS     | Local Hosting       | Local Peering         |
| Banking Service    | Cloud + CDN         | Local Cache           |

This shifts the discussion from:

> What exists?

to:

> What could be improved?



# Connecting Findings to IXPs

An Internet Exchange Point creates the most value when:

* Multiple networks participate.
* Content is available locally.
* Traffic can remain within the country.

The analysis can help identify:

| Indicator             | Relevance                          |
| --------------------- | ---------------------------------- |
| Local hosting         | Potential local traffic            |
| Educational platforms | High local demand                  |
| Government services   | National importance                |
| Media organisations   | Content localisation opportunities |
| CDN presence          | Potential cache deployments        |



# Example IXP Observation

A balanced statement might be:

> The analysis identified several locally hosted educational and organisational services. These services could potentially benefit from local traffic exchange, reducing reliance on international transit and improving user experience.

Notice that this does not claim:

* An IXP is required.
* An IXP will automatically solve the problem.

It simply identifies an opportunity.



# Suggested Tables for Reports

## Top ASNs

| ASN     | Organisation        | Count |
| ------- | ------------------- | ----- |
| AS13335 | Cloudflare          | 364   |
| AS16509 | Amazon Web Services | 44    |
| AS63949 | Example Provider    | 26    |



## IPv6 Summary

| Metric           | Value  |
| ---------------- | ------ |
| Domains Analysed | 458    |
| IPv6 Domains     | 188    |
| IPv6 Adoption    | 41.04% |



## Hosting Classification

| Category      | Count |
| ------------- | ----- |
| Local Hosting | X     |
| Cloud Hosting | Y     |
| CDN Hosted    | Z     |
| Hybrid        | N     |



## Key Organisations

| Organisation      | Sector     | Hosting Model |
| ----------------- | ---------- | ------------- |
| University        | Education  | Hybrid        |
| Government Agency | Government | Cloud         |
| News Organisation | Media      | CDN           |



# Suggested Graphs

Useful visualisations include:

* Top ASN bar chart.
* Hosting category pie chart.
* IPv6 adoption chart.
* Sector distribution chart.

Keep graphs simple and focused on key messages.



# Writing for Different Audiences

## Technical Audience

Focus on:

* DNS
* BGP
* ASN data
* IPv6 statistics

Example:

> AS13335 represented approximately 62% of observed IP addresses.



## Policy Audience

Focus on:

* Local content
* Digital development
* Infrastructure resilience

Example:

> The analysis suggests opportunities to increase local hosting of nationally important services.



## Executive Audience

Focus on:

* Outcomes
* Risks
* Opportunities

Example:

> Several critical services remain dependent on international infrastructure, while locally hosted educational platforms demonstrate opportunities for increased content localisation.



# Common Mistakes

## Confusing Correlation with Causation

Incorrect:

> Cloudflare caused IPv6 adoption.

Correct:

> Cloudflare may contribute to observed IPv6 availability.



## Assuming DNS Reveals Hosting Location

Incorrect:

> The website is hosted in the United States.

Correct:

> The service uses infrastructure operated by a provider registered in the United States.



## Overstating Conclusions

Avoid:

> The country has poor infrastructure.

Prefer:

> The analysis suggests limited evidence of locally hosted services within the observed dataset.



# Suggested Report Structure

A typical report might contain:

1. Executive Summary
2. Methodology
3. Domain Statistics
4. IPv6 Analysis
5. ASN Analysis
6. Cloud and CDN Analysis
7. Key Organisations
8. Content Localisation
9. Opportunities and Observations
10. Limitations
11. Conclusions



# Example Executive Summary

> Analysis of the most popular domains within the selected country-code Top-Level Domain identified widespread use of Content Delivery Networks and cloud infrastructure. IPv6 was available on approximately 41% of analysed domains, although much of this appears to be associated with cloud and CDN platforms. Several educational and organisational services were identified as locally hosted, indicating opportunities for local traffic exchange and content localisation initiatives.



# Limitations

Remember:

* DNS does not prove hosting location.
* CDNs may hide origin infrastructure.
* Anycast routing can influence observations.
* Cloud platforms may operate globally.
* Popularity rankings change over time.

Results should therefore be interpreted as indicators rather than absolute truths.



# Final Thoughts

The purpose of this workflow is not to determine the exact location of every service.

Instead, it provides a repeatable and evidence-based method for understanding:

* Internet ecosystem maturity
* Hosting patterns
* IPv6 deployment
* Content localisation opportunities
* Potential value of local infrastructure initiatives

Used carefully, these findings can support:

* Technical research
* Internet governance discussions
* IXP development
* Digital transformation initiatives
* Public policy analysis

---

# Next Steps

Possible future enhancements include:

* Top 100 domain analysis from Cloudflare Radar.
* Traceroute and path analysis.
* CDN cache identification.
* Internet Exchange Point traffic studies.
* Longitudinal measurements over time.
* Comparison of multiple ccTLDs.

At this point you have completed the core workflow and should have a comprehensive dataset suitable for further analysis and reporting.
