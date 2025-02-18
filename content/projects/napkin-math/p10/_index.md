# problem 10

https://sirupsen.com/napkin/problem-10

Is MySQL’s maximum transactions per second equivalent to fsyncs per second?

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

## Attempt


## Solution



