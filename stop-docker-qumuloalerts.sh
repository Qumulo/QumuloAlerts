#!/bin/bash

# Uncomment if runnning in a Docker Swarm

# docker stack rm storagereport

# This stops a container running in a Docker stand-alone configuration
# Comment out this group of lines if you need to stop a Docker Swarm

docker container stop storagereport
docker container rm storagereport

