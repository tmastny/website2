---
title: "Problem 6"
---

# Problem 6

https://sirupsen.com/napkin/problem-6

## Attempt

### Personal website 

```bash
# pages
rg --files --glob '*.{md,Rmd}' | wc -l
```
* 102 ~ 100 pages

```bash
# bytes
rg --files --glob '*.{md,Rmd}' | xargs wc -c 
```
* 443007 bytes ~ 450 * 10^3 bytes = 450 KB

#### Network

Given that my website is a simple static website,
the client can't make a special request to receive
all webpages in one request.

Let's go with Network NA East <-> West
for our latency
* 60 ms / request * 100 requests = 6 seconds

Then to download each page at 25 MB/s:
* 1 s / 25 * 10^6 bytes * 0.45 * 10^6 bytes = 18 ms

Searching for key words in memory is fast:
* 100 us / 1 MB * 450 KB = 100 us / 10^6 bytes * 0.45 * 10^6 bytes = 45 us

6 seconds is not a good UX: 
but _if_ we could request all pages in one request,
the performance would be
* 60 ms + 18 ms = 78 ms

That's "instant" from the user perspective.

### NYT


