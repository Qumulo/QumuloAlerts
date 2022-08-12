$env:QUMULOALERTS_VERSION = "0.6.4"
$env:ALERTS_CONFIGDIR = "./config/alerts/"
$env:CONSUMER_CONFIGDIR = "./config/consumer/"

# If you have a docker swarm, then uncomment the following line and
# comment the line on "docker-compose up"

# docker stack deploy --compose-file docker-compose.yml storagereport

# The following line is how you start a docker instance when you do not
# have a docker swarm

docker network create --driver bridge --attachable qumuloalerts

docker compose -f .\docker-compose-windows.yml up --detach

                                                                                                                                                                                                                                                                                                                                                                                                                                                     