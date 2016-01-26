#!/bin/bash
set -e

if [[  ( "$1" = 'init') || ( ! -d /var/kalan-container/web2py/applications/admin )  ]]; then

  cp -a /var/kalan-container/web2py/applications-backup/. /var/kalan-container/web2py/applications/


fi
chown -R kcontainer:kcontainer /var/kalan-container/web2py/applications/
exec /usr/bin/python /var/kalan-container/web2py/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"

#exec "$@"
