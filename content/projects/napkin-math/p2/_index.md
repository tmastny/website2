---
title: "Problem 2"
date: 2024-02-06
---

# Problem 2

https://sirupsen.com/napkin/problem-2

Problem #2: Your SSD-backed database has a usage-pattern that rewards
you with a 80% page-cache hit-rate 
(i.e. 80% of disk reads are served directly out of memory instead of going to the SSD).
The median is 50 distinct disk pages for a query to gather its query results 
(e.g. InnoDB pages in MySQL). 
What is the expected average query time from your database?


## Assumptions

* 50 pages * 80% pages in cache = 40 pages in cache
    * 50 * 80% = 50% * 80% = 40
* 50 pages * 20% pages on disk = 10 pages on disk

Sequential SSD read: 
* 1 us / 8KB * 16KB / page = 2 us / page

Page scan time:
* 1 ns / 4 bytes * 16KB / page = 4000 ns / page (4 us / page)

Total: 
* 50 pages * 4 us / page = 200 us
* 10 pages * 2 us / page = 20 us
* 200 us + 20 us = 220 us

> note: this seems too slow. Small difference
> between cached and disk pages 

Reference sheet says 0.5 ns / 64 bytes. 
Let's try something closer. 

Page scan time:
* 1 ns / 64 bytes * 16KB / page = 250 ns / page = .25 us / page

Total:
* 50 pages * .25 us / page = 12.5 us
* 10 pages * 2 us / page = 20 us
* 12.5 us + 20 us = 32.5 us

> These results look more reasonable:
> the cost for accessing disk is much larger,
> matching my expectations. 

The reference sheet also mentions MySQL query as
500 us, but unsure if that's relevant here. 
That would completely overshadow the cost of
accessing disk, which does not seem right.  

## Solution

https://sirupsen.com/napkin/problem-3

Key idea I did not realize: each page access
in the SSD is _random_: we aren't sequentially 
reading the 10 pages. 

So random SSD read of 8KB is 100 us.
That's only half a page, but the sequential
SSD read is 1 us per 8 KB, so 101 us ~ 100 us.
for napkin math
* 100 us / page * 10 pages = 1000 us = 1 ms

This makes way more sense: now the query time
is totally dominated by the disk I/O as expected
(since we correctly identified that all the page 
reads will be about 12 us, which is 1% of the total).

Curious how to reason about MySQL overhead: 
the reference sheet cryptically mentions 
"500 us" for a query, but is that per page? 
That would the time at 25 ms, which would dominate
the disk I/O which does not seem right.
* The solution says up to 10ms to account for overhead. 
* 5 ms / 50 pages = 0.1 ms / page seems reasonable.
