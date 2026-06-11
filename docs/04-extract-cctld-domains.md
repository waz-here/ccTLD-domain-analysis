# Extracting ccTLD Domains

## Overview

After downloading the Cloudflare Radar Top 1 Million Domains dataset, the next step is to extract domains that belong to a specific country-code Top-Level Domain (ccTLD).

For example, if you are analysing Samoa, you may want to extract all domains ending in:

```text
.ws
```

If you are analysing Fiji, you may want:

```text
.fj
```

If you are analysing Vanuatu, you may want:

```text
.vu
```

This chapter explains how to extract those domains using `awk`.



# Learning Objectives

By the end of this chapter you will be able to:

* Extract domains belonging to a specific ccTLD.
* Understand why `awk` is preferred over simple `grep` for this workflow.
* Count extracted domains.
* Remove duplicates.
* Save extracted domains into a reusable text file.
* Adapt the workflow to different ccTLDs.



# Why Use awk?

There are many ways to search a text file in Linux.

A simple approach might use `grep`:

```bash
grep "\.ws$" cloudflare-top-1m.csv
```

This can work if the file contains only one domain per line.

However, `awk` is more flexible and safer for structured text files such as Comma-Separated Values (CSV) files.

## Why awk is Useful

`awk` can:

* Split lines into fields.
* Select a specific column.
* Perform case-insensitive matching.
* Apply regular expressions.
* Print only the data you need.
* Handle future changes in the dataset more cleanly.

For this project, `awk` is preferred because it allows us to clearly say:

> Check the domain field, and only return rows where the domain ends with the selected ccTLD.

This reduces accidental matches.



# A Note About the Dataset Format

The Cloudflare Radar dataset format may vary slightly depending on how it was downloaded.

It may appear as:

```csv
example.com
example.net
service.example.ws
```

or it may include additional columns such as rank and domain:

```csv
1,example.com
2,example.net
3,service.example.ws
```

For this repository, the examples assume the file contains the domain name in the **first column**.

If your file contains a rank in the first column and the domain in the second column, use `$2` instead of `$1` in the `awk` command.



# Set a ccTLD Variable

Instead of hard-coding `.ws`, define a variable.

This makes the command reusable.

```bash
TLD="ws"
```

Do not include the leading dot.

Use:

```bash
TLD="ws"
```

not:

```bash
TLD=".ws"
```

This makes later pattern matching easier.



# Extract Domains for a ccTLD


For Samoa run:

```bash
TLD="ws"

awk -F, -v tld="$TLD" 'tolower($1) ~ "\\." tld "$" {print $1}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```

This creates:

```text
ws-domains.txt
```



# What Does This Command Do?

```bash
awk -F, -v tld="$TLD" 'tolower($1) ~ "\\." tld "$" {print $1}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```

| Part                    | Meaning                               |
| ----------------------- | ------------------------------------- |
| `awk`                   | Text-processing tool                  |
| `-F,`                   | Use comma as the field separator      |
| `-v tld="$TLD"`         | Pass the shell variable into `awk`    |
| `tolower($1)`           | Convert the first column to lowercase |
| `~`                     | Match against a regular expression    |
| `"\\."`                 | Match a literal dot                   |
| `tld`                   | Match the selected ccTLD              |
| `"$"`                   | Match the end of the line or field    |
| `{print $1}`            | Print the first field                 |
| `cloudflare-top-1m.csv` | Input file                            |
| `>`                     | Redirect output to a file             |
| `"${TLD}-domains.txt"`  | Output file                           |



# Why Match the End of the Field?

The dollar sign (`$`) is important.

It means:

> Match only if the ccTLD appears at the end of the domain.

This prevents false matches.

For example, when searching for `.ws`, this should match:

```text
service.example.ws
```

but not:

```text
service.example.ws.example.com
```



# Verify the Output

Display the first few extracted domains:

```bash
head "${TLD}-domains.txt"
```

Example output:

```text
service.example.ws
government.example.ws
university.example.ws
```

Count the results:

```bash
wc -l "${TLD}-domains.txt"
```

Example output:

```text
523 ws-domains.txt
```



# Remove Duplicates

The dataset should normally contain unique domains, but it is good practice to remove duplicates.

```bash
sort -u "${TLD}-domains.txt" > "${TLD}-domains-unique.txt"
```

Then replace the original file:

```bash
mv "${TLD}-domains-unique.txt" "${TLD}-domains.txt"
```

Count again:

```bash
wc -l "${TLD}-domains.txt"
```



# Adapting the Command for Other ccTLDs

To analyse Fiji:

```bash
TLD="fj"

awk -F, -v tld="$TLD" 'tolower($1) ~ "\\." tld "$" {print $1}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```

To analyse Vanuatu:

```bash
TLD="vu"

awk -F, -v tld="$TLD" 'tolower($1) ~ "\\." tld "$" {print $1}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```

To analyse Tonga:

```bash
TLD="to"

awk -F, -v tld="$TLD" 'tolower($1) ~ "\\." tld "$" {print $1}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```



# If Your Dataset Has Rank and Domain Columns

Some datasets may look like this:

```csv
1,example.com
2,example.net
3,service.example.ws
```

In this case, the domain is in the second column.

Use `$2` instead of `$1`:

```bash
awk -F, -v tld="$TLD" 'tolower($2) ~ "\\." tld "$" {print $2}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```



# If Your Dataset Has a Header Row

Some CSV files include a header row such as:

```csv
rank,domain
1,example.com
2,example.net
3,service.example.ws
```

Use:

```bash
awk -F, -v tld="$TLD" 'NR > 1 && tolower($2) ~ "\\." tld "$" {print $2}' cloudflare-top-1m.csv > "${TLD}-domains.txt"
```

## What Does `NR > 1` Mean?

`NR` means:

> Number of Records

In `awk`, a record usually means a line.

So:

```text
NR > 1
```

means:

> Ignore the first line.

This skips the header row.



# Quick Check for File Structure

Before deciding whether to use `$1` or `$2`, inspect the first few lines:

```bash
head cloudflare-top-1m.csv
```

If the file looks like:

```text
example.com
example.net
service.example.ws
```

use `$1`.

If the file looks like:

```text
1,example.com
2,example.net
3,service.example.ws
```

use `$2`.

If the file looks like:

```text
rank,domain
1,example.com
2,example.net
3,service.example.ws
```

use `$2` and `NR > 1`.



# Optional: Compare with grep

A simple `grep` search can be useful for a quick check:

```bash
grep -i "\.${TLD}$" cloudflare-top-1m.csv | head
```

However, this is less precise when working with structured CSV files.

Use `grep` for quick inspection.

Use `awk` for repeatable analysis.



# Common Mistake: Forgetting to Escape the Dot

In regular expressions, a dot (`.`) means:

> Match any character.

So this command is not ideal:

```bash
grep ".ws$" cloudflare-top-1m.csv
```

It can match more than intended.

Use:

```bash
grep "\.ws$" cloudflare-top-1m.csv
```

or preferably use the `awk` method shown earlier.



# Create a Summary

You can create a small text summary:

```bash
echo "ccTLD analysed: .$TLD" > "${TLD}-summary.txt"
echo "Domains found: $(wc -l < "${TLD}-domains.txt")" >> "${TLD}-summary.txt"
```

View the summary:

```bash
cat "${TLD}-summary.txt"
```

Example:

```text
ccTLD analysed: .ws
Domains found: 523
```



# Troubleshooting

## No Domains Found

If the output file is empty:

```bash
wc -l "${TLD}-domains.txt"
```

returns:

```text
0 ws-domains.txt
```

check the following:

### Confirm the dataset exists

```bash
ls -lh cloudflare-top-1m.csv
```

### Inspect the file format

```bash
head cloudflare-top-1m.csv
```

### Check whether the ccTLD appears at all

```bash
grep -i "\.${TLD}$" cloudflare-top-1m.csv | head
```

### Try the second column version

```bash
awk -F, -v tld="$TLD" 'tolower($2) ~ "\\." tld "$" {print $2}' cloudflare-top-1m.csv | head
```



## Results Include Unexpected Domains

If your results include domains that do not actually end in the selected ccTLD, check that:

* The dot is escaped as `"\\."`
* The pattern ends with `"$"`
* You are matching the correct column



## File Contains Windows Line Endings

If the file was downloaded or edited on Windows, it may contain carriage return characters.

These can appear as:

```text
^M
```

Convert the file using:

```bash
sudo apt install dos2unix

dos2unix cloudflare-top-1m.csv
```

Then rerun the extraction command.



# Output Created in This Chapter

At the end of this chapter you should have:

```text
ws-domains.txt
```

or equivalent for your selected ccTLD.

Example:

```text
fj-domains.txt
vu-domains.txt
to-domains.txt
```

This file becomes the input for the DNS analysis in the next chapter.



# What Comes Next?

The next chapter resolves the extracted domains to IP addresses.

You will learn how to query:

* A records for IPv4
* AAAA records for IPv6

Continue to:

```text
docs/05-dns-analysis.md
```
