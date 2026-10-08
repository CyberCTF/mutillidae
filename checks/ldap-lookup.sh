#!/bin/sh
# Logs in as admin / adminpass (an account the database setup creates), then the conference room
# lookup (an LDAP lab) finds room 1F104: the directory is loaded and the web server reaches it.
jar=$(mktemp)
curl -fsS -c "$jar" -b "$jar" -o /dev/null \
  --data "username=admin&password=adminpass&login-php-submit-button=Login" \
  "http://www/index.php?page=login.php" || exit 1
curl -fsS -c "$jar" -b "$jar" "http://www/index.php?page=conference-room-lookup.php&default_room_common_name=1F104" |
  grep -q "<td>1F104</td>"
