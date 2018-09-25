# Gaia

[![Circle
CI](https://circleci.com/gh/NotyIm/gaia.svg?style=svg)](https://circleci.com/gh/NotyIm/gaia)

Gaia is NotyIM heart, it requests website, store data into InfluxDB.
Once it has data, it checks the data to see if it matches a set of
criteria. If yes, it creates an incident in system.

# Gaia interface

We interact with GaiA via a HTTP interface:


- POST: /monitor/
    - id:
    - address:

- DELETE: /monitor/{id}
    stop monitoring this website

- PUT: /monitor/
    - id:
    - address:
    Update

# Batch processing

On current hosting, we run 30 go-routine, each go-routine check a list
of service sequential.

# Distributed mode

Gaia can run on two modes:

- server
- agent

## Agent mode

Agent only run check and give server the result of check. Agent doesn't
need to know about storage or source of data. Agent simply connect to
server to retrieve a list of services. It runs check on those service,
and push result to server for storing

## Server mode

Server mode at the same time can also run as an agent. Server run
checks, accept result from agent, flush into storage backend.
