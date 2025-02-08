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

Estimated bytes per page:
* 450 KB / 100 pages = 4.5 KB
* 1 word / 6 bytes * 4.5 * 10^3 bytes / page = 750 words / page

That seems reasonable!

> Aside: next time I should start in reverse: 
> instead of measuring my personal website, come up with 
> an estimate and then verify it.

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

How big is the NYT? Let's say
each article is 1000 words
and they publish 10 articles a day.

> this estimate I'm not very confident about,
> because I don't follow websites like the NYT. 
> My initial thought was 100 articles a day,
> but that's probably too high. 

Let's say the last 100 years have been
digitized and are available online on their
website.

Then:
* 6 bytes / word * 10^3 words / article * 10^1 articles / day *
  365 days / year * 10^2 years = 6 * 365 * 10^7 words ~
  2.2 * 10^3 * 10^6 = 2.2 * 10^9 = 2.2 GB

Then:
* 2.2 * 10^9 bytes / (10^1 articles / day * 3.65 * 10^2 days / year * 10^2 years) =
  2.2 * 10^9 bytes / (3.65 * 10^5 articles) ~ 0.6 * 10^4 bytes = 6 KB / article 

One request per article then would be:
* 60 * 10^-3 / request * 3.65 * 10^5 requests = 21.9 seconds

That's just latency: then we also have to download the 2.2 GB:
* 1 s / 25 * 10^6 bytes * 2.2 * 10^9 bytes = 0.09 * 10^3 ~ 90 s

So even if we downloaded all the articles in one request, 
and pay a latency of time of 60 ms, the download time is still 90s!

So it's not feasible for the NYTs to download all the articles and search them.

Out of curiousity, the time to find a simple keyword
with a linear scan through the articles:
* 100 * 10^-6 s / 10^6 bytes * 2.2 * 10^9 bytes = 220 * 10^-3 s = 220 ms

Actually not that bad! But real bottleneck is the download time. 
That's an "instant" UX feel.

## Solution



