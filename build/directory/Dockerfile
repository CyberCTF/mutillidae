# Upstream's ldap Dockerfile (build/www/docker/.build/ldap/Dockerfile) with the base image pinned to
# osixia/openldap:1.5.0 (upstream: osixia/openldap:latest, which is 1.5.0). The www machine loads
# upstream's LDIF into it at start.
FROM osixia/openldap:1.5.0

# Set up the LDAP configuration
ENV LDAP_ORGANISATION="Mutillidae Inc"
ENV LDAP_DOMAIN="mutillidae.localhost"
ENV LDAP_BASE_DN="dc=mutillidae,dc=localhost"
ENV LDAP_ADMIN_PASSWORD="mutillidae"
ENV LDAP_CONFIG_PASSWORD="mutillidae"
ENV LDAP_TLS="false"
