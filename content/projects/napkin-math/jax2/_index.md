# Thinking about TPUs

MXU performances
```
bf16[8,128] @ bf16[128, 128] -> f32[8, 128]
```
every 8 cycles.

## q1

Ref:

TPU v4p	
* HBM cap: 32 GB 
* HBM bandwidth between HBM and tensor core
  (through VMEM)
    * 1.2e12 bytes/s

How long to load 200B parameter model in bf16, 
split between 32 TPU v4ps, 
from HBM to systolic array?

200e9 * 2 = 400e9 bytes
400e9 bytes / 32 TPUs = 12.5e9 bytes/TPU
So each TPU needs 12.5 GB, within HBM cap.

Then we can stream that to the tensor core at 1.2e12 bytes/s:
* 12.5e9 bytes / 1.2e12 bytes / s = 10.4 ms

Maybe 20.8 ms because we have to stream it out too?

### solution

This represents sampling: generating the next token.

We also need to leave capacity in the TPU for data,
not just the parameters.

## q2

> Consider a full TPU v5e pod. 
> How many total CPU hosts are there? 
> How many TPU TensorCores? 
> What is the total FLOPs/s for the whole pod? 
> What is the total HBM? 
> Do the same exercise for TPU v5p pod.

full v5e pod
* 16x16

CPU hosts
* 1 CPU connected to 8 TPUs with 4x2 topology
* 16 * 16 TPUs / 8 TPUs / CPU = 32 CPUs

Cores
* 1 core per TPU * 16*16 TPUs = 256 cores

FLOPs/s
* 1.97e14 * 256 = 5e16  

HBM
* 16*16 TPUs * 16 GB/TPU = 4096 GB


## q3







