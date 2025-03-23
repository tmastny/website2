---
title: "Problem 10"
date: 2024-02-26
---

# problem 10

https://sirupsen.com/napkin/problem-10

Is MySQL's maximum transactions per second equivalent to fsyncs per second?

fsync background
* when calling `write` on a file, the data is stored in the OS's page buffer
* data is not immediately flushed to disk. There are factors such as 
  timers and percent of dirty pages that determine when the data is flushed.
* The purpose is twofold:
    * **temporal locality**: data accessed recently is likely
      to be accessed again soon. So the OS does not want to waste time putting
      the data on file if it's going to be needed soon.
    * **write coalescing**: if more data is written to the same file soon
      after the initial write, the OS can flush the data all together 
* But dbs have a different constraint: they need their data to persist
  even a server crashes to prevent data loss, so they need the data to be
  flushed to disk right away (the data, or a log of the operations at least).
* That's the purpose of `fsync`: it's called on the file descriptor
  and forces all dirty pages of that file to be flushed to disk.

ref: 
* `fsync`: 1ms
  * actually ensures file is flushed to disk
* network: 10 us
* `write`: 10 us
  * lower latency, because will write to OS's page cache

Maximum theoretical writes per second:
* 1 fsync / 1ms * 1000 ms / s = 1000 fsyncs / s


## Attempt

Where does a transaction "end"? If it ends when MySQL
inserts a new record into WAL and successfully calls `fsync`,
then isn't the answer 1000?

Or do we also need to estimate the time to insert the records
into the page? That would be B+ tree insertion.
* search for the page should be about 400 ns, a couple of pointer
  jumps to reach the leaf node. 
* Then you have load the page into memory. If on disk, that's 100 us
  for a random page. Then write to the page is negligible, since
  it's all in cache memory. 
* So about 100 us? That's still pretty insignificant compared to
  the 1ms `fsync` time.

The page we write to is now in the buffer pool, but we mark it as
dirty: we don't flush it to disk right away, since we've flushed the
WAL and so can recovery from a crash.

## Solution

When we benchmark against MySQL, we are able to get 5300 insertions per second.
That's significantly faster than the expected fsync time!

The reason why we have more fsyncs than expected is because
there's a group commit scheme to binlog and wal.

But it's unclear why fsync is _faster_ than 1ms. Perhaps due to
file system batching together writes. 




