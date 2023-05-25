#!/bin/bash

export MARIADB_VERSION=latest

export INFLUXDB_VERSION=2.6.1
export INFLUXDB_CONFIGDIR=$(PWD)/influxdb/config

export QUMULOALERTS_VERSION=6.0.1
export ALERTS_CONFIGDIR=$(pwd)/config/alerts/

export CONSUMER_CONFIGDIR=$(pwd)/config/consumer/

# The following line is how you start a docker instance when you do not
# have a docker swarm

docker network create --driver bridge --attachable qumuloalerts

# If you have a docker swarm, then uncomment the following line and
# comment the line on "docker-compose up"

# docker stack deploy --compose-file docker-compose.yml qumuloalerts

docker compose up --detach


