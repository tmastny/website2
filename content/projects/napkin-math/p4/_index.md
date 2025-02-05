---
title: "Problem 4"
---

# Problem 4

https://sirupsen.com/napkin/problem-4

## Attempt

Redis: single-threaded in memory key-value store.
If the key was an integer, should be as fast as looking
up a value from main memory, or 50 ns according to ref.
Especially because each "value" is <64 bytes, a single
cache line.

According to the ref, the throughput of 64 bytes of random
memory is 1 GB/s. 

But our system is getting:
* 10^4 requests/s * 64 bytes/request = 640 KB/s
* way too slow!

Upper bound on requests/s:
* 10^9 bytes/s / 64 bytes/request = 15 million requests/s

Networking:
* ref: throughput of 4 GB/s, faster than random memory
* latency: 10 us per 32 KB. 

What if we were only sending 64 bytes per TCP data packet?
* 64 bytes / 10 us = 6.4 MB/s
* 6.4 * 10^6 bytes/s / 64 bytes/request = 10^5 requests/s

That's only 10x off from the 640 KB/s we're getting.

## Solution

How Redis 6 works:
* Threaded I/O does not manage 1 connection per thread
* event-driven I/O like epoll or kqueue monitors socket fds
  for new data. 
* I/O threads handles reading and writing to the socket
* data is sent to the main thread via a buffer.
* main thread processes requests and writes to a reply buffer
  for I/O threads to read and send to a socket 


