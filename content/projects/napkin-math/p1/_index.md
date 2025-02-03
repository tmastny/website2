---
title: "Problem 1"
---

# Problem 1

https://sirupsen.com/napkin/problem-1

Problem #1: How much will the storage of logs cost for a standard, monolithic 100,000 RPS web application?

## Assumptions

Let's estimate annualized cost of logs.

Say each request generates 100KB of logs.
* 100,000 requests/s * 100KB/request = 10GB/s
* 10GB/s * 3600s/hour * 24hours/day * 365days/year = 32TB/year

### Blob

Say we can put them in blob storage:
* 1 year commitment $ / month = $0.025 / GB / month
* 32 TB / 12 months = 2.67 TB / month
* 2670 GB * $0.025 / GB / month = $66.75 / month
* $66.75 / month * 12 months/year = $801 / year

But we don't usually need to keeps longs that long. 
Let's say we only keep last three days
* 10GB/s * 3600s/hour * 24hours/day * 3days = 2.592TB
* 2.592TB / 12 months = 0.216TB / month
* 0.216TB * $0.025 / GB / month = $5.4 / month
* $5.4 / month * 12 months/year = $64.8 / year

Ah, but we are also charged by writes to blob.
Let's start with 1 write per request.
* 100,000 requests/s * 1 write/request = 100,000 writes/s
* $0.005 / 1000 writes * 100,000 writes/s = $0.5 / s
* $0.5 / s * 3600s/hour * 24hours/day * 365days/year = $15,768,000 / year

Napkin math technique: let's batch writes by 1000. 
Then our answer just changes by a factor of 1000.
* 100,000 requests/s * 1 write/ 1000 request = 100 writes/s
* $15,768,000 / year / 1000 = $15,768 / year

Another thousand: $15.768 / year
* batch up to 1GB of data per write. 

### Logs

Alternatively, logs pricing is $0.5 / 1 GB. 
For one year:
* 10GB/s * 3600s/hour * 24hours/day * 365days/year = 32TB/year
* 32TB * $0.5 / GB = $16,000 / year

For three days:
* 10GB/s * 3600s/hour * 24hours/day * 3days = 2.592TB
* 2.592TB * $0.5 / GB = $1,296 / year

## Solution

https://sirupsen.com/napkin/problem-2

Differences
* estimated bytes / request off by 100.
    * solution is 1KB, mine was 100KB

I didn't think to estimate how much we fits into 1KB.
* 1 character per byte, or 1000 characters. 
* `wc p1.md` (before this bullet) is about 2KB,
  so 1KB seems right order of magnitude for a log. 

I also like computing with scientific notation.
Let's walk through it:
* 10^5 requests/s * 10^3 bytes / request = 10^8 bytes / s (0.1 GB/s)
* 10^8 bytes/s * 9 * 10^4 seconds / day = 9 * 10^12 bytes / day (9 TB / day)
* 9 * 10^12 bytes / day * 3 * 10^1 days = 27 * 10^13 bytes per month
* 27 * 10^13 bytes / month * $0.02 / 10^9 bytes / month = $5400 / month

Solution also used disk storage pricing at $0.01 GB / mont.
Possibly don't have to pay for writes at this level?

Writes get pricey:
* $5 / 10^6 writes * 10^5 writes / s = $0.5 / s
* $0.5 / s * 9 * 10^4 seconds / day * 30 days = $1,350,000 / month

Write every 1000 requests:
* 10^3 bytes / request * 10^3 requests / batch = 10^6 bytes / batch (1 GB / batch)
* 10^5 requests / s * 1 batch / 10^3 requests = 10^2 batches / s
* 10^2 writes / s * $5 / 10^6 writes = $0.0005 / s
* $0.0005 / s * 9 * 10^4 seconds / day * 30 days = $1350 / month
