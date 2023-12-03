#!/bin/bash

export MARIADB_VERSION=latest

export INFLUXDB_VERSION=2.6.1
export INFLUXDB_CONFIGDIR=$(pwd)/influxdb/config

export QUMULOALERTS_VERSION=6.3.0
export ALERTS_CONFIGDIR=$(pwd)/config/alerts/

export CONSUMER_CONFIGDIR=$(pwd)/config/consumer/

# The following line is how you start a docker instance when you do not
# have a docker swarm

docker network create --driver bridge --attachable qumuloalerts

# We need to make sure that the Grafana storage location has all
# permissions or it will fail

chmod 777 grafana-storage

# If you have a docker swarm, then uncomment the following line and
# comment the line on "docker-compose up"

# docker stack deploy --compose-file docker-compose.yml qumuloalerts

docker compose up --detach


