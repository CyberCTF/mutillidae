# Upstream

| Dir | Repository | Version | Commit | Licence |
| --- | --- | --- | --- | --- |
| `build/www/app/` | https://github.com/webpwnized/mutillidae | main (2.12.7) | 126a1fdb4ff977f87e980d018f0def477afc3d5d | GPL-3.0 |
| `build/www/docker/` | https://github.com/webpwnized/mutillidae-docker | main (1.0.77) | b5920113ad30dd92c893b2f44230fb5bf99f3601 | GPL-3.0 |

Neither repository publishes releases, so both are the default branch at those commits,
unchanged, without their Git history. The Dockerfiles under `build/` are upstream's
(`build/www/docker/.build/*/Dockerfile`), each with a header comment saying what differs:

- every base image is pinned (upstream uses `latest`): `php:8.5-apache`, `mariadb:11.8`,
  `phpmyadmin:5.2.3-apache`, `osixia/openldap:1.5.0`, `osixia/phpldapadmin:0.9.0`;
- the web server copies the application from `build/www/app/src` instead of cloning the default
  branch at build time, and its configuration from `build/www/docker/.build/www/configuration/`;
- the web server runs `build/www/setup.sh` at start, which builds the database
  (`set-up-database.php`) and loads upstream's LDIF into the directory once.

Upstream's two networks (`datanet`, `ldapnet`) are one network here. To update, replace both
folders with newer commits, then change this table.
