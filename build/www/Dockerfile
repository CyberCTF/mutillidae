# Upstream's www Dockerfile (docker/.build/www/Dockerfile, from webpwnized/mutillidae-docker) with
# these changes:
# - the base image is pinned to php:8.5-apache (upstream: php:apache);
# - the application is copied from app/src (the vendored webpwnized/mutillidae) instead of a
#   `git clone` of the default branch at build time, so git is not installed;
# - the Apache configuration is copied from docker/.build/www/configuration/;
# - ldap-utils is installed and the command first starts setup.sh in the background, which builds
#   the database (set-up-database.php, as upstream's README says to do once) and loads upstream's
#   LDIF (docker/.build/ldap/configuration/ldif/mutillidae.ldif) into the directory machine, so
#   the lab starts ready. Both steps are skipped when already done.
# Everything else is upstream's.
FROM php:8.5-apache

# Arguments with default values, but can be overidden
ARG DATABASE_HOST="database"
ARG DATABASE_USERNAME="root"
ARG DATABASE_PASSWORD="mutillidae"
ARG DATABASE_NAME="mutillidae"
ARG DATABASE_PORT="3306"
ARG ENABLE_ERROR_REPORTING=true

RUN apt-get update

RUN apt-get install --no-install-recommends -y libldap2-dev
RUN docker-php-ext-install ldap

RUN apt-get install --no-install-recommends -y libxml2-dev
RUN docker-php-ext-install xml

RUN apt-get install --no-install-recommends -y libonig-dev
RUN docker-php-ext-install mbstring

RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev
RUN docker-php-ext-install curl

RUN docker-php-ext-install mysqli

RUN apt-get install --no-install-recommends -y dnsutils iputils-ping ntpsec ldap-utils

COPY app/src /var/www/mutillidae
RUN mkdir -p /var/www/mutillidae/data /var/www/mutillidae/passwords && \
    chown -R www-data:www-data /var/www/mutillidae/data /var/www/mutillidae/passwords && \
    chmod -R 775 /var/www/mutillidae/data /var/www/mutillidae/passwords && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -M phinius -p 123456

# Use development version of the PHP ini file
# Make PHP vulnerable to RFI again
# Ensure the PHP server banner shows in the HTTP response
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i 's/allow_url_include = Off/allow_url_include = On/g' /usr/local/etc/php/php.ini && \
    sed -i 's/allow_url_fopen = Off/allow_url_fopen = On/g' /usr/local/etc/php/php.ini && \
    sed -i 's/expose_php = Off/expose_php = On/g' /usr/local/etc/php/php.ini

# Conditionally enable error reporting if ENABLE_ERROR_REPORTING is true
RUN if [ "$ENABLE_ERROR_REPORTING" = "true" ]; then \
    sed -i 's/^error_reporting = .*/error_reporting = E_ALL/' /usr/local/etc/php/php.ini && \
    sed -i 's/^display_errors = .*/display_errors = On/' /usr/local/etc/php/php.ini; \
    fi

# Remove the .htaccess file since the containers will use container network security rather than htaccess access control
# Change the database configuration variables in the mutillidae project, allowing the user to override using build arguments
# Change the hostname of the ldap server to the docker ldap hostname
RUN rm /var/www/mutillidae/.htaccess && \
    sed -i "s/define('DB_HOST', '127.0.0.1');/define('DB_HOST', '$DATABASE_HOST');/" /var/www/mutillidae/includes/database-config.inc && \
    sed -i "s/define('DB_USERNAME', 'root');/define('DB_USERNAME', '$DATABASE_USERNAME');/" /var/www/mutillidae/includes/database-config.inc && \
    sed -i "s/define('DB_PASSWORD', 'mutillidae');/define('DB_PASSWORD', '$DATABASE_PASSWORD');/" /var/www/mutillidae/includes/database-config.inc && \
    sed -i "s/define('DB_NAME', 'mutillidae');/define('DB_NAME', '$DATABASE_NAME');/" /var/www/mutillidae/includes/database-config.inc && \
    sed -i "s/define('DB_PORT', 3306);/define('DB_PORT', $DATABASE_PORT);/" /var/www/mutillidae/includes/database-config.inc && \
    sed -i 's/127.0.0.1/directory/' /var/www/mutillidae/includes/ldap-config.inc

RUN mkdir /etc/apache2/conf/ && \
    mkdir /etc/apache2/error-pages/

COPY docker/.build/www/configuration/https-certificate/mutillidae-selfsigned.crt /etc/ssl/certs/mutillidae-selfsigned.crt
COPY docker/.build/www/configuration/https-certificate/mutillidae-selfsigned.key /etc/ssl/private/mutillidae-selfsigned.key
COPY docker/.build/www/configuration/apache-configuration/conf/error-pages.conf /etc/apache2/conf/error-pages.conf
COPY docker/.build/www/configuration/apache-configuration/conf/headers.conf /etc/apache2/conf/headers.conf
COPY docker/.build/www/configuration/apache-configuration/error-pages/404.html /etc/apache2/error-pages/404.html
COPY docker/.build/www/configuration/apache-configuration/error-pages/oops.jpg /etc/apache2/error-pages/oops.jpg
COPY docker/.build/www/configuration/apache-configuration/conf-available/aliases.conf /etc/apache2/conf-available/aliases.conf
COPY docker/.build/www/configuration/apache-configuration/sites-available/mutillidae.conf /etc/apache2/sites-available/mutillidae.conf

# Change the localhost references to listen on external network interfaces
# Unlink access log and error log so the log files can be written in the container
# Make sure access log and error log exist
# Enable Apache TLS modules
# Disable the default site because it intercepts calls to Mutillidae made by IP address
# Enable the mutillidae site
RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/apache2/sites-available/mutillidae.conf && \
    sed -i 's/127.0.0.2/0.0.0.0/' /etc/apache2/sites-available/mutillidae.conf && \
    unlink /var/log/apache2/access.log && \
    unlink /var/log/apache2/error.log && \
    touch /var/log/apache2/access.log && \
    touch /var/log/apache2/error.log && \
    a2enmod ssl && \
    a2dissite 000-default && \
    a2ensite mutillidae

COPY docker/.build/ldap/configuration/ldif/mutillidae.ldif /usr/local/share/mutillidae/mutillidae.ldif
COPY setup.sh /usr/local/bin/mutillidae-setup
CMD ["sh", "-c", "sh /usr/local/bin/mutillidae-setup & exec apache2-foreground"]

EXPOSE 80
EXPOSE 443
