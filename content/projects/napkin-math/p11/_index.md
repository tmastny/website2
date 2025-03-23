---
title: "Problem 11"
date: 2024-02-28
---

# problem 11

https://sirupsen.com/napkin/problem-11-circuit-breakers

The circuit breaker pattern is a way to fail fast
and prevent a failure from cascading: or causing
significant slowdowns and problems outside of the
originating service.

In his example, if a store is unresponsive, 
the API doesn't get an immediate response, but rather
a timeout error after 5 seconds. 

If we have 4 workers that normally process a request in 100ms,
that's:
* 1 req / 100e-3 s = 10 req/s  
* 1 req / 5 s = 0.2 req/s * 4 = 0.8 req/s

That's a huge difference: the 100th connection in line
is now waiting >100 seconds for a response instead of 
2.5 seconds. 

The idea of the circuit breaker is that a service
monitors all requests and if it detects too many timeouts
or failures, the service _instantly_ responds to the caller
with a failure, rather than waiting for the long timeout. 
> one problem with setting a threshold is that you extend
> the downtime. If your timeout is 5 seconds, and you need 5 failures,
> that's 15 seconds of downtime. 

This preserves the number of requests per second, which is useful
is only a small component of the system is causing the excessive timeout.
In the first case, _everything_ slowed down because workers were hung up
on the 5 second timeout. But now those are immediately resolved and the
workers can server other requests.

The next part of the circuit breaker is an internal timer to try
again, after say 15 seconds.

## implementation

The circuit breaker is implemented in the application layer,
using close to the middleware. 

They are usually handled in the HTTP middleware:
```
client -> reverse proxy -> http middleware -> application code
                           ^----------------------------------^
                                    application layer
```

The http middleware is the responsible for
* security
* request/response parsing
* logging
* performacnce
  * rate limiting
  * timeouts
  * circuit breaking

In Flask, middleware tasks are often implemented as decorators
at the method level of the application code.
```python
class SessionStore:
    @circuit(failure_threshold=3, recovery_timeout=15)
    def get_session(self, session_id):
        return self.redis_client.get(f"session:{session_id}")
```

## bulkheading

A related concept is bulkheading. Let's say some service requests
are _slow_ but not unresponsive. 
The idea is to analyze the number of workers typically needed
to be connected a service, and limit the total number of workers
based on that number.

For example, set a limit of 5 connections to a database shard.
If a 6th tries to connect, they fail. 

Other examples:
* services with a fixed connection pool. Once they consume their pool,
  they can't serve any more requests. But other services with separate
  connection pools can continue to work with the database.

Circuit breakers and bulkheads work well together: 
* circuit breakers alone can result in total loss of capacity
  until the breaker is flipped
* bulkheads can limit the say reduce the loss of capacity
* together, the bulkhead can limit the loss and the circuit breaker
  can total recover capacity by flipping the breaker









