# problem 14

https://sirupsen.com/napkin/problem-14-using-checksums-to-verify

* 100M records
* 1KB per record
    * 100e6 * 1e3 = 100e9 = 100GB

## What if we just downloaded each record and compared them?

Let's say we are comparing Postgres and Snowflake,
so the data is not in the same zone or region: we need to go 
over the internet. 

Network:
* 100 GB * 25 MB / s = 100e9 / 25e6 / s = 4000 seconds ~ 1 hour
Off SSD:
SSD:
* 100e9 / 4e9 / s = 25 seconds
Serialiazation:
* 100e9 / 100e6 / s = 1000 seconds ~ 15 minutes

Let's say we just download and compare two columns, 
`id` and `updated_at`:
* 2 * 8 bytes = 16 bytes
* 16 bytes / record * 100e6 records = 1.6e9 bytes = 1.6GB
* 1.6e9 bytes / 25e6 bytes/s = 64 seconds


What about hashing speeds for a checksum?
* 100e9 bytes / 2e9 bytes/s = 50 seconds
* 1.6e9 bytes / 2e9 bytes/s = 0.8 seconds!
* 25 seconds to read from SSD




