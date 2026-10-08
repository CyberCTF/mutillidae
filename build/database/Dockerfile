# Upstream's database Dockerfile (build/www/docker/.build/database/Dockerfile) with the base image pinned
# to mariadb:11.8 (upstream: mariadb:latest).
FROM mariadb:11.8

# Set environment variable for MySQL root password
ENV MYSQL_ROOT_PASSWORD="mutillidae"

# Combine apt-get commands and handle failures gracefully
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* || true
