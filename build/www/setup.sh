#!/bin/sh
# Prepares the lab at start, once: builds the Mutillidae database (set-up-database.php, the link
# the "database offline" page offers) and loads upstream's LDIF into the directory machine (the
# ldapadd command upstream documents). Each step is skipped when it is already done, so a restart
# keeps what the player changed.
db_ready() {
  php -r 'exit(@mysqli_connect("database","root","mutillidae","mutillidae")?->query("SELECT 1 FROM accounts LIMIT 1") ? 0 : 1);' >/dev/null 2>&1
}
ldap_ready() {
  ldapsearch -x -H ldap://directory -D "cn=admin,dc=mutillidae,dc=localhost" -w mutillidae \
    -b "ou=users,dc=mutillidae,dc=localhost" -s base dn >/dev/null 2>&1
}
db=0 ldap=0
for i in $(seq 1 150); do
  if [ $db = 0 ]; then
    if db_ready; then db=1; echo "mutillidae-setup: database ready"
    else curl -fsS -o /dev/null http://127.0.0.1/set-up-database.php 2>/dev/null; fi
  fi
  if [ $ldap = 0 ]; then
    if ldap_ready; then ldap=1; echo "mutillidae-setup: directory ready"
    else ldapadd -c -x -H ldap://directory -D "cn=admin,dc=mutillidae,dc=localhost" -w mutillidae \
      -f /usr/local/share/mutillidae/mutillidae.ldif >/dev/null 2>&1; fi
  fi
  [ $db = 1 ] && [ $ldap = 1 ] && exit 0
  sleep 2
done
echo "mutillidae-setup: setup failed (database $db, directory $ldap)"; exit 1
