#!/bin/bash

# Uncomment if runnning in a Docker Swarm

# docker stack rm qumuloalerts

# This stops a container running in a Docker stand-alone configuration
# Comment out this group of lines if you need to stop a Docker Swarm

docker container stop email
docker container stop clicksend
docker container stop alerts
docker container stop exchange
docker container stop influxdb

docker container rm email
docker container rm clicksend
docker container rm alerts
docker container rm exchange
docker container rm influxdb

# Finally, remove the shared network

docker network rm qumuloalerts

