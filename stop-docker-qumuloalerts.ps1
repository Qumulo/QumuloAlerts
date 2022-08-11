#!/bin/bash

# Uncomment if runnning in a Docker Swarm

# docker stack rm qumuloalerts

# This stops a container running in a Docker stand-alone configuration
# Comment out this group of lines if you need to stop a Docker Swarm

docker container stop qumuloalerts-email-1
docker container stop qumuloalerts-ifttt-1
docker container stop qumuloalerts-alerts-1
docker container stop qumuloalerts-exchange-1

docker container rm qumuloalerts-email-1
docker container rm qumuloalerts-ifttt-1
docker container rm qumuloalerts-alerts-1
docker container rm qumuloalerts-exchange-1

# Finally, remove the shared network

docker network rm qumuloalerts

