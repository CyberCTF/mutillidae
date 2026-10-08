# Upstream's database_admin Dockerfile (build/www/docker/.build/database_admin/Dockerfile) with the base
# image pinned to phpmyadmin:5.2.3-apache (upstream: phpmyadmin:latest).
FROM phpmyadmin:5.2.3-apache

# The name of the database container
ENV PMA_HOST="database"

# Create credentials
ENV MYSQL_ROOT_PASSWORD="mutillidae"
ENV PMA_USER="root"
ENV PMA_PASSWORD="mutillidae"

# Try to patch the container but do not fail if patching fails
# Remove the apt-get lists after installation
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* || true

# Open port 80 to the webserver
EXPOSE 80
