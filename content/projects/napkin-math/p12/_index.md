# problem 12

https://sirupsen.com/napkin/problem-12-recommendations

How long it take to run this algorithm to find similar users
for a million users and a million products?

## Attempt

Cosine similiarity between two users:
```python
for i in range(len(products)):
    dot += user1[i] * user2[i]
    sum_sq1 += user1[i] * user1[i]
    sum_sq2 += user2[i] * user2[i]

sim = dot / (sqrt(sum_sq1) * sqrt(sum_sq2))
```

Immediatelly the problem is the O(n^2) pairwise comparison.
For each user, we'd have to compare them to every other user:
* 1e6 * 1e6 = 1e12 comparisons

Then each comparsion we need to do ~1e6 operators, 
one for each product:
* 1e12 comparsions * 1e6 products / comparsion = 1e18 ops

If we are (very) optimistic and say 1 byte / ops:
* 1e18 bytes / 10e9 bytes/s = 1e6 seconds = 11.5 days!

But maybe we can just run do 1e6 comparisons for a single user at a time:
* 1e6 comparisons * 1e6 bytes / comparison = 1e12 bytes
* 1e12 bytes / 10e9 bytes/s = 100 seconds

Somehow we have to cut down on our data.
Maybe each product is mapped into categories? 
If we can cut down to 1e3 products:
* 1e3 products * 1e6 users = 1e9 ops
* 1e9 ops / 10e9 ops/s = 0.1 seconds
which would be a manageable latency after the initial page load.

We could also significantly filter users too. 
Maybe we have we prefer users to who have made 5+ purchases,
in the same category, in the last year. 


## Solution

Need a denser representation! I assumed bytes, but why not a bitarray?
* 1e6 bits / user = 125 KB / user
* 1e6 users * 125e3 bytes / user = 125 GB
* 125 GB / 10 GB / s = 12.5 seconds

Still too slow, but as we saw before we can really cut it down
by filtering users or products. 
> Note: a key filtering technique is to use a sparse representation:
> only store the non-zero values. 
> The aligns perfectly with our computation, becaues the dot product
> is zero if either value is zero.

We can also precompute this quantify
offline (refreshing frequently too since it takes 12.5 seconds).

Precomputing is where O(n^2) comes into play. We need to do 
this for 1e6 users:
* 1e6 users * 12.5 seconds / user = 12.5e6 seconds = 144 days = 20 weeks

That's a long time! But we can run this in parallel.
Recall CPUs are $15 / month, so $150 / month to run 100,
or $1800 / year. That's pretty cheap for a recommendation system,
which likely pays for itself. 

* At 100 CPUs, we can do 12.5e4 seconds = 1.5 days
* 1000 CPUs, 12.5e3 seconds = 3.5 hours
  * at $18,000 per year, update recommendations continuously.

We could also do something like $0.005 / CPU / hour. Run 200 CPUs
and finish in .75 days. 
* 18 hours * 200 CPUS * $0.005 / CPU / hour = $18 / day
* $6570 / year to update recommendations once a day.

### item-to-item similarity

We found user similarity: find other users who made similar purchases
based on cosine similarity. 

Complexity: O(MN) where M is the number of users and N is the number of items
to create the matrix.
```python
for user in users:
    for item in items:
        if user.purchased(item):
            matrix[user][item] += 1
```

O(M^2N) to compute the similarity between all users. O(MN) for "online".
```python
for user1 in users:
    for user2 in users:
        sim = 0
        for item_id in item_ids:
            sim += matrix[user1][item_id] * matrix[user2][item_id]
            # sum of squares
```


But imagine we are in the cart and want to see similar items. 
Now we need an `item x item` matrix to calculate the similarity
between the items. 

```python
for item in items:
    for user in users:
        if user.purchased(item):
            for other_item in items:
                if user.purchased(other_item):
                    matrix[item][other_item] += 1
```

So building the matrix is O(N^2M) where N is the number of items
and M is the number of customers.

Then to compute the similarity offline is O(N^3), O(N^2) online:
```python
for item1 in items:
    for item2 in items:
        sim = 0
        for item_id in item_ids:
            sim += matrix[item1][item_id] * matrix[item2][item_id]
```







