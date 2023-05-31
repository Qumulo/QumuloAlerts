#!/bin/bash

# Uncomment if runnning in a Docker Swarm

# docker stack rm qumuloalerts

# This stops a container running in a Docker stand-alone configuration
# Comment out this group of lines if you need to stop a Docker Swarm

docker compose down -t 60

# Finally, remove the shared network

docker network rm qumuloalerts

