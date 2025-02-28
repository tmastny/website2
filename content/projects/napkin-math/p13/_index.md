# problem 13

https://sirupsen.com/napkin/problem-13-filtering-with-inverted-indexes

Filtering on attributes:
* if products have 100s to 1000s attributes, it's
  impractical to filter on a combination of attributes in a traditional
  relational database _fast_ (<10ms)
    1. need a row for each attribute (and an index on each attribute)
    2. using multiple indexes are slow
        * you can use _composite_ indexes: indexes that are a combination
          of multiple columns (see [Problem 7](../p7/)), but is impratical
          with so many columns
        * the database can also do an _index merge_: the database finds
          all matching rows from each index separately, and then merges
          them together (with intersection, union, etc) in a result set.
          This is better than a full table scan, but we need <10ms time!

How do inverted indexes solve this problem?

## Attempt

While a small inverted index might be done in memory as a hash table, 
efficiently finding keys in a search database like Lucene is solved by
using a _Finite State Transducer_. The FST is a fast and efficient trie.
Where a normal tree is a set of nodes with poitners to child nodes,
FST is a simliar structure, but efficiently implemented as an array
with offset "jumps" to the next node in the array, and also has
pointers to the matching document list. 

Now, let's say we have 10 million documents, 3 attributes with 1.2 million
products each. For a simple in-memory inverted index, what's the query time?

As discussed in [Problem 3](../p3/), one option is hashing each value or
using a bloom filter. But I realized in [Problem 9](../p9/) that the
product ids are sorted, which gives us a much faster algorithm. 

For each pair of attributes, we need to do effectively do a merge sort,
but only keeping the duplicates. This is effectively a sequential scan of 
1.2 * 3 = 3.6 million products.
* 3.6e6 * 8 bytes = 30 MB
* 30e6 / 10e9 / s = 3e-3 = 3 ms 

<10 ms! That could work for our web request.

## Solution

One insight note from the solution is interpreting the 
CPU processing speed of 1GB/s as the memory bandwidth limit.
In other words, this is how much data we can read from memory into the CPU.

The author noted that at 40 MBs and beyond, the time is significantly slower:
because it's not a issue of loading the data, it must be that the CPU
is having to process more and more data. This is a hint that more threads
could make it significantly faster, which turned out to be the case. 

Likewise, "merge sorting" is inherently parallel, since each thread
can take a pair of lists and find the intersection. 

