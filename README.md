# OWASP Mutillidae II

[OWASP Mutillidae II](https://github.com/webpwnized/mutillidae) by Jeremy Druin (webpwnized): a
free, deliberately vulnerable PHP web application with more than 40 vulnerabilities, hints and
security levels. This repository runs it with [Isoloom](https://www.isoloom.com):
[`isoloom.yml`](isoloom.yml) describes the machines, built from the vendored application
([`build/www/app/`](build/www/app)) and the upstream container setup
([`build/www/docker/`](build/www/docker), from
[mutillidae-docker](https://github.com/webpwnized/mutillidae-docker)), with the database built and
the LDAP directory loaded at first start.

| Machine | Service |
| --- | --- |
| www | Mutillidae (Apache, PHP) on ports 80 and 443 |
| database | MariaDB 11.8 on port 3306 |
| directory | OpenLDAP on port 389 |
| database-admin | phpMyAdmin on port 80, published on 81 |
| directory-admin | phpLDAPadmin on port 80, published on 82 |

## Run it

```bash
isoloom generate
isoloom run docker
```

Then open http://mutillidae.localhost/ (or http://localhost/). phpMyAdmin is on
http://localhost:81/ (root / mutillidae) and phpLDAPadmin on http://localhost:82/
(`cn=admin,dc=mutillidae,dc=localhost` / mutillidae). The same spec runs as Docker on a local VM
(`docker-vm`), on a cloud VM (`cloud-docker`) or on Kubernetes. Lab guide: the hints in the
application and the [webpwnized YouTube tutorials](https://www.youtube.com/user/webpwnized).

Upstream versions and commits: [UPSTREAM.md](UPSTREAM.md).

## Licence

GPL-3.0, as Mutillidae and mutillidae-docker ([LICENSE](LICENSE)). This application is
deliberately vulnerable: keep it isolated.
