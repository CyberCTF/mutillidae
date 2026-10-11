#!/bin/sh
# Places the player's flag (CTF_FLAG_MAIN, given by the launcher) where command execution on the web server reaches it;
# without one (CI, a run by hand) the development flag.
dev='FLAG{dev-mutillidae}'
printf '%s\n' "${CTF_FLAG_MAIN:-$dev}" > /ctf/flag
chmod 444 /ctf/flag
