---
title: "Problem 5"
---

# Problem 5

https://sirupsen.com/napkin/problem-5

## Attempt

### q1

> What is the performance of the query in the worst-case, where we load only one product per page?

Ref:
* random SSD: 100 us per 8KB
* sequential SSD: 1 us per 8KB
* total 101 ~ 100 us

For 100 pages:
* 100 * 100 us = 10 ms
* 100 * 1 us = 100 us
* total: 10.1 ms

### q2

> (2) What is the worst-case performance of the query when the pages are all in memory cache (typically that would happen after (1))?

* random access: 
    * 50 ns
    * 100 pages * 50 ns = 5 us
    * technically ignoring additional cache line loads, 
      but I'm assuming the prefetcher kicks in
* sequential scan: 
    * 1 MB / 100 us
    * 100 pages * 16 * 10^3 bytes / page = 1.6 MB
    * 1.6 10^6 bytes * 100 us / 10^6 bytes = 160 us

Total: 165 us

We would also need to add this time to the answer in q1.
But the disk read is so much slower,
we can basically ignore the in-memory scan. 

### q3

> If we changed the primary key to be (shop_id, id), what would the performance be when (3a) going to disk, and (3b) hitting cache?

The overall disk and memory load and scan times would be the same.
What changes is how many pages we need to read. 

We are given that we have an index of the form `(shop_id, id)`, 
so the individual pages will be sorted by `shop_id` first, then by `id`:
```
shop_id | id
1       | 1
1       | 2
1       | 4
2       | 1
2       | 10
2       | 13
```

Likewise, the B+ tree index will quickly give us the 
first page containing `shop_id = 13`. And in B+ trees,
leaf nodes are linked together, so we can iterate through the
page entries, and then go on to the next pages until
we find 100 records. 

#### pages

The diagram implies 8 records per page, but that does 
not seem realistic. If the page only stored
* shop_id
* id
* page number
* page offset

That would be
* 16 * 10^3 bytes / page * 1 record / 32 bytes = 500 records / page

Let's say for some reason it's not just an index page, 
but also has other data. If we had 10 columns at 8 bytes each,
that's still about 200 records per page. 

So either way, we only need to look at 1 page. 

If it _was_ 8 records per page, then we would need
to load 13 pages. 

#### q3a

Random 8KB SSD:
* 13 * 100 us = 1.3 ms

#### q3b

random access:
* 13 * 50 ns = 650 ns = 0.65 us

sequential scan:
* 1 MB / 100 us  
* 13 pages * 16 * 10^3 bytes / page = 208 KB
* 208 * 10^3 bytes * 100 * 10^-6 seconds / 10^6 bytes = 20.8 us

## Solution

https://sirupsen.com/napkin/problem-6

Their sequential scan estimate is:
* 16 * 10^3 bytes / 64 bytes * 5 ns = 1.25 us

We said: 
* 16 * 10^3 bytes / 10^6 bytes * 100 us = 1.6 us

Which was a little slower, but in the right ballpark. 
I like my estimate, only because 1 MB / 100 us is easy to remember. 

Lastly, they make a reasonable estimate that the each record is 128 bytes:
* 1 record / 128 bytes * 16 * 10^3 bytes / page = 125 records / page

So I'm glad I estimated that and thought that through!




