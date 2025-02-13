# Problem 9

https://sirupsen.com/napkin/problem-9

## Attempt

### (a)

`title AND see`: this is almost identical
to our analysis from [problem 3](../p3).
* 3 * 10^6 ids * 8 bytes / id = 24 MB
* sequential scan: 24 MB * 100 us / 1 MB = 2.4 ms 
* each id have to add to hash table: 50 ns lookup
  hash in main memory.
    * 50 ns * 3 * 10^6 ids = 
    * 50 * 10^-9 * 3 * 10^6 = 150 * 10^-3 = 150 ms
* total: ~150 ms 

That's once everything is in memory. On disk?
That depends how it's stored. If each id list
is stored sequentially, then we just have a random
access and then a sequential read about 2 million ids.
* 2 * 10^6 ids * 8 bytes / id = 16 MB
* 100 us / access + 200 us / 1 MB * 16 MB = 420 us

So we could say ~1ms to read off disk.

### (b)

With this approach, `title OR see` the performance
is identical. The difference is that instead of adding
an element into a hash map and then only including it
in the output if it's already there, we just add
every element to the hash map to deduplicate. 

### (c)

From benchmark:
```
AndHighHigh: +title +see # freq=2077102 freq=1100862
```

Not totally sure where the actual benchmark is,
but this might be it: https://benchmarks.mikemccandless.com/CombinedAndHighHigh.html
If so, it looks like it's about 10 ms, which is close
to the 2.5 ms (but that was only the sequential scan, not the hash lookup). 

Also, that benchmark file from the post might be
running 5 different `AND`s, which would imply 2 ms
for `title AND see` specifically.

### (d)

From ref:
* sort 5 ms / 1 MB * 24 MB = 120 ms, 
  worst case since interserction is likely smaller

## Second attempt

### (a)

I noticed that in the post's image the list of product
ideas were sorted...

In [problem 3](../p3) I mentioned sorting
as a potential algorithm to look for intersections
in an inverted index. 

I noted that it might be faster than a hash table,
but probably slower than a bloom filter. 
What I did not consider was that the list
might be _stored_ sorted. That would save an 
enormous amount of time. 

This lead me to study how inverted indexes store
the attributes and ids. Here's a brief overview
of what I found:
* each attributes are called terms and product ids
  are called documents
* documents are given a unique id upon insert that's
  greater than any other. 
* This means each term's document list is sorted:
  the order is arbitrary, but since the list is
  sorted, it's easy and fast to find the intersection
  of with another term's document list. 
* when you execute a query, you find all the segments
  for each term and you merge them (like merge sort)

So given that the ids are sorted, how much faster
can we find the intersection?

Now the algorithm would look like this:
```python
intersection = []
title, see = 0, 0
while title < len(title_ids) and see < len(see_ids):
    if title_ids[title] == see_ids[see]:
        intersection.append(title_ids[title])
        title += 1
        see += 1
    elif title_ids[title] < see_ids[see]:
        title += 1
    else:
        see += 1
```

Now the total time is a sequential scan of the
3 million uint64s: 
* 100 us / 1 MB * 24 MB = 2.4 ms
* plus some overhead for each iteration
  (branch misses, addition, checks, etc.)
  let's say 5 ms total.

That's much closer to the 10 ms (or 2 ms) we got
from the nightly benchmark. 


## Solution

https://sirupsen.com/napkin/problem-10




