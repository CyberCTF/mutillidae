# Upstream's ldap_admin Dockerfile (build/www/docker/.build/ldap_admin/Dockerfile) with the base image
# pinned to osixia/phpldapadmin:0.9.0 (upstream: osixia/phpldapadmin:latest).
FROM osixia/phpldapadmin:0.9.0

# The hostname of the ldap service configured in docker-compose.yml configuration
ENV PHPLDAPADMIN_LDAP_HOSTS="directory"

# Whether to use HTTPS (port 443) or HTTP (port 80) for web interface
ENV PHPLDAPADMIN_HTTPS="false"

# Try to patch the container but do not fail if patching fails
# Remove the apt-get lists after installation
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* || true

# Open port 80 through the firewall
EXPOSE 80
