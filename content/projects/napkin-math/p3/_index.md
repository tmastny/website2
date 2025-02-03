---
title: "Problem 3"
---

# Problem 3

https://sirupsen.com/napkin/problem-3

## Attempt


Worse case:
* 1,000,000 product ids in 4 attributes

Data size:
* 1,000,000 `int64` is 8 * 10^6 bytes = 8 MB
* 4 attributes = 32 MB


Speed for set membership tests:
hash value and then random read into hash table.
(not sure if using the rate is correct: 
I'm assuming I can do do the hash and random read
while iterating over attributes and product ids)
* Hash
    * 1 MB / 500 us
* Random read
    * 1 MB / 1 ms
i.e.
```python
matched = set()
ids = []
for attribute in attributes:
    for id in attribute.product_id:
        if id in matched:
            ids.append(id)
        else:
            matched.add(id)
```

Overall:
* 32 MB * 500 us / 1 MB = 16 ms
* 32 MB * 1 ms / 1 MB = 32 ms
* Total = 48 ms

Does this meet product requirements?
Say you are on a shopping website and 
you need the filter to return at a reasonable speed.
According to Claude:
* sub 100ms feels truly instant to users, so 48 ms is good!

Maybe each attribute list is in a different disk file:
* 4 * 100 us = 0.4 random SSD reads
* 4 * 8 * 200 us sequential disk reads for 32 MB = 6.4 ms
* an additional 7 ms 
    * does not change human perception of speed

## Solution

https://sirupsen.com/napkin/problem-4

Things I investigated the solution did not:
* hashing and random read costs

### Sequential read

Missed approach: I forgot to count the sequential 
memory read: I assumed it was negligible I think.

Ref: sequential read is 100 us / 1 MB
* 32 MB * 100 us / 1 MB = 3.2 ms

So the additional 3.2 still keeps us less than 60 ms.

### Memory vs disk

I calculated what it would be if each attribute was stored
on disk, but that analysis was a little shallow. 

First, how many attributes total? Let's say 1000.
Then that's 8 MB * 1000 = 8 GB, probably more
than we would want to keep in memory, but not impossible. 

And keeping 8 MB per attribute in a file is reasonable,
since it would only take 7 ms to read that from disk. 

### Disk speeds

In memory we calculated 3.2 ms. 
For disk, I calculated 7 ms:
* 4 * 100 us / 1 MB = 0.4 ms
* 4 * 8 * 200 us / 1 MB = 6.4 ms

Looking back, it doesn't make sense that reading from disk is only 
twice as slow. Rule of thumb: SSD is 10x cheaper, 10x slower than disk. 

Claude says 1 ms / 1 MB is a good approximation. And that would
agree with the 10x 100 us / 1 MB for sequential reading in memory.

That leaves me confused about the reference stating Sequential SSD
read is 200 us / 1 MB, but Claude and the blog post agree. 

With this new estimate, what is the latency?
* 32 MB * 1 ms / 1 MB = 32 ms

But this is the same as hashing and random read...

#### hash and random read

This made me realize my estimates were way too high for
hashing and random read. 
* a typical `int64` hash is usually just XOR, shift, and multiply
* and a random read is just 100 ns

Random read:
* 64 bytes / 50 ns * 1 GB / 10^9 bytes * 10^9 ns / 1 s = 1.28 GB / s

But we don't need to read 32 MB randomly.
We pay the 50 ns once for each element we look up in the hash table:
* 4 * 10^6 * 50 * 10^-9 s = 200 * 10^-3 s = 200 ms

That's actually significantly worse than I calculated before. 

So in total: 
* sequentially reading 32 MB: 3.2 ms
* hash is insignificant additional time
* 200 ms for each random jump into the hash table
* total: 203.2 ms

Still managable! No longer "instant", but humans tolerate it. 

### Cost

Cost is something I did not consider at all. 

Let's assume we want to store 8 GB in memory. 
That's 8 GB *  $1 / GB / year = $8 / year.
Even if we needed to double that to effectively work
with the data in memory (to create the hash table, for example),
that's still only $16 / year.

Now if we have 1000 merchants, that's $16,000 / year.

SSD was 10x cheaper, so $1600 / year which is very manageable,
and still fits latency budget.

### Algorithm 

Could we use a bloom filter? 
For 1,000,000 bits, that's 125 KB. That could fit in L2 cache,
part of it in L1 cache. 

And I don't think it would thrash the sequential reading cache:
we would only need the next few cache lines of the sequential scan
to continue that quickly (i.e. good streaming).

If there is a match in the filter, it could be a false positive.
So we would need a backup hash map to check for sure.
But if we have a false positive rate of 1%, that's only 40,000
extra elements, or 40,000 * 50 ns = 2 * 10^-3 s = 2 ms of extra time.

Recall: we compute 4 hashes, giving a number between 0 and 999,999.
Each number is mapped into that bit array.

So let's say
* 2 ns for 4 hashes
* 4 ns lookup in L2 cache, 4 times
* 24 ns 

So say 10 ns per element
* 4 * 10^6 * 24 * 10^-9 s = 96 ms

Much faster than hash map!

### Algorithm 2

Sorting?

1 s / 200 MB * 32 MB = 160 ms.

Just sorting all of them is slower,
and we still would need someway to process
through them and associate them with attribute.

So bloom filter is best bet.
