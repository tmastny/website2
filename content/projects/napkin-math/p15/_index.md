---
title: "Problem 15"
date: 2025-03-17
---

# problem 15

https://sirupsen.com/napkin/problem-15

Initial TCP congestion window:
- to check for congestion, the sender will send 10 packets
  and wait for a response from _all_ before sending any more.

Why?
- if the receiver cannot handle the slow rate, it won't be able to
  handle a faster rate, wasting the sender's capacity
- if there is broader congestion on the network, the sender
  will contribute to the problem, without getting any faster
  responses from the receiver
  - in the worst case, causes network collapse
- adaptive: find the fastest rate without causing congestion

So sender could send 10 packets small packets very quickly.
If sending coast-to-coast, the fastest possible ACK would be
60 ms (RTT, round trip time).
* but we also need to include the 3-way handshake
* 60 ms: SYN, SYN-ACK
* 120 ms: ACK/GET, ACK/response with first bytes

So how much data in the initial window?
* 10 packets * 1440 bytes / packet = 14400 bytes = 14.4 KB

So if the sender could packet an entire website in that window,
the receiver would be able to load the website in 120 ms rather
than 180 ms or more (saving at least one round trip time).

I think that's reasonable for a small static blog:
* 1 character / byte * 5 words / character * 500 words = 2500 bytes
* I honestly don't have a good estimate for the size of HTTP headers,
  HTML, CSS, etc. But I can't imagine it being more than 2500 bytes. 
* So if each component is 2500, then 2500 * 4 = 10000 bytes = 10 KB! 
  We could send the entire page in the initial congestion window.

Let's check the math by looking at the size of my blog:
* my [homepage](https://timmastny.com) is 2KB
  * 688KB if you count my font! Maybe I should use a standard one... 
* a [post](https://timmastny.com/blog/visualizing-cpu-pipelining/) with lots of JavaScript animation and svgs is 161KB 
* my [most popular post](https://timmastny.com/blog/a-star-tricks-for-videogame-path-finding/) full of gifs is 7.5MB!
* a basic, text-only [post](https://timmastny.com/blog/garbage-collection-crafting-interpreters/) is 8KB

I'm very happy to send imagines and JavaScript animations,
but the font is way more than I thought! I might have to go through
some of the standard fonts again. 

## Solution
5 round trips for client to receive first HTML byte from server:

* 1 DNS - ignored because often cached or close by
* 1 TCP - SYN, SYN+ACK (next is ACK and TLS handshake at the same time)
* 2 TLS - (TLS connection, Cert+key), (key, acknowledge)
* 1 HTTP - GET, HTML

Example: at 60 ms RTT from US coast-to-coast: 
that's 300 ms to first HTML byte. 
And you can only receive 14.4 KB of data until you have to send the first ACK,
which is another 60 ms RTT for set of data 
(assuming no congestion, the server should sent 28.8 KB, doubling each round trip
according to it's congestion control algorithm).
* 10 packets * 1440 bytes / packet = 14400 bytes = 14.4 KB

