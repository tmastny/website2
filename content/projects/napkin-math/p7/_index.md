---
title: "Problem 7"
---

# Problem 7

https://sirupsen.com/napkin/problem-7

## Attempt

### (a)

Let's estimate size of a row:
* id, revision: 2 * 8 bytes = 16 bytes
* name: 12 bytes
* desc: 20 words * 6 bytes / word = 120 bytes
* when_updated: 8 bytes
* subtotal: 16 + 12 + 120 + 8 = 156 bytes
    * let's add half of that again for some random columns 78
* total: 234 bytes ~ 200 bytes = 0.2 KB

Updates:
* 10 updates/s * 2 * 10^2 bytes / update = 2 KB/s
* 2.5 * 10^6 s/month * 2 * 10^3 bytes/s = 5 * 10^9 bytes/month = 5 GB/month
* 5 GB/month * 12 months/year = 60 GB/year

That doesn't seem so bad: am I missing something? 
Given the preamble, is there exponential growth hiding anywhere?

I don't think so:
* each update only generates one new row.
* it would be exponential if each update generated a new row
  for all previous revisions
    * then it would grow like: 1, 2, 4, 8, 16, ...,
      geometrically. 

Cost:
* this is a database, so we are hosting it on a server
  with an SSD. 
* Zonal SSD: ($0.2 / 1 GB) / month 
    * 60 GB * $0.2 / GB = $12 
    * $12 / month * 12 months/year = $144 / year

So after 10 years, we would need an SSD with 600 GB just to hold 
our revisions. 
* again, I don't think this is growing exponentially but it's a
  a big SSD.

### (b)

Could we store it in a relational database?
* one benefit is that if we had row-level updates or deletes,
  it's unlikely to block normal read-functionality of the app,
  which would typically be looking at the latest revision.
    * so we could have a background job writing the old revisions
      to longterm storage and deleting them from the main database. 
* blob storage is 10x cheaper, so would only be $14.4 / year.
    * it's also not crucial we store and delete the old revisions right away,
      so we can save on blob insert costs.

Storing more efficiently:
* one improvement is to make sure the old revisions are on disc
  and the latest revisions are more likely to be in memory. 
* `(id, revision)` groups rows with a common `id` together. 
* Instead we want to group the latest revisions together, 
  because read queries typically will only look for the latest revision:
  `(revision, id)`

`(id, revision)` vs. `(revision, id)` 
```
id | revision         id | revision
1  | 1                1  | 1
1  | 2                2  | 1
1  | 3                3  | 1
2  | 1                2  | 2
2  | 2                3  | 2
3  | 1                4  | 2
```

Now we are more likely to keep old revisions on disc and 
newer revisions in memory. 
* for example, let's say updates are evenly distributed across 
  all rows. Eventually, all rows will update at least once. 
  That means `revision = 1` will always be on disc for normal
  inserts and reads. 
* with `(id, revision)`, if we searched for `id = 1`, we would
  load `id = 1 and revision = 1` into memory, even though we
  don't need `revision = 1`. 

The problem here is that the latest revision per rows are not grouped
together. If id 1 is on revision 10, and id 2 on revision 100
it's unlikey they would ever be loaded into memory together. 
We'd have to load 10 and 100 revisions into memory, when we really
want the _latest_ revisions in memory. 

Proposal: new boolean column `is_latest`, with index `(is_latest, id)`:
```
id | revision | is_latest
1  | 10       | true
2  | 100      | true
```

This achieves what we want most! Now reads and updates will always be ran
with `where is_latest = true`. Those values are all grouped together, so 
are much more likely to be in memory, and old revisions can stay on disc
until they are migrated off. 

As an side, you'd now likely want to create a view such as `latest_products`
with `where is_latest = true`, since the typical CRUD operations 
would not want to waste time querying revisions, and you don't want to 
accidentally forget and have a really slow query.  

### overall

I feel like I'm missing something, but I'm not sure what:
* 10 updates/s is our fixed assumption, so the rate of updates
  is not growing. 
* it's relatively inexpensive to copy an entire row, so we don't
  have to pay much for storage.
* maybe database performance is an issue, but the question is
  about storage costs. 

## Solution

https://sirupsen.com/napkin/problem-8


* 256 bytes per product
  * I estimated 234 and then rounded to 200. Not bad!
* 80 GB / year, $8 / month
  * 60 GB / year, $12 / month
  * he calculated at $0.01 / GB, I did $0.02 / GB
  * Pretty good! I really thought I was missing something here.

Mentions decreased performance, which I was worried about.
* in particular, given the current index, you will always
  fetch up "useless" rows, i.e. rows with outdated revisions.

Solution suggests some problematic cases:
* I was considered about growing revisions, but even
  random sporadic behavior by a single merchant could cause problems,
  if they are constantly creating revisions. 

Mentions compression: 
* good idea, we'd be storing a lot of near identical data. 
* Even though I mentioned needing to think about compression in 
  the last problem, I didn't realize databases could implement compression.
  * But in general, there's no reason the underlying file on disc couldn't 
    be compressed. There would be decompression overhead:
    * ref: x compression ratio decreases 10x performance
    * 2x on English is 200 MB / s
    * 3x is 20 MB / s
* useful to think about, but that would only move us from 60 GB / year
  to 20-30 GB / year: not a ton of benefit

Solution did not mention alternate indices, so I'm proud I got that one. 











