#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e
if [[ ( ! -d /var/kalan-container/web2py/applications/admin ) ]];then
  cp -a /var/kalan-container/web2py/. /var/kalan-container/k-w2p/
fi

if [[  ( "$par1" = 'init')  ]]; then
  echo "Starting kalan normal mode"
  chown -R kcontainer:kcontainer /var/kalan-container/k-w2p/applications/
  exec /usr/bin/python /var/kalan-container/k-w2p/web2py.py --nogui -i 0.0.0.0 -p 8888 -a "<recycle>"

fi
if [[  ( "$par1" = 'initadmin') && ( -n "$par2" ) ]]; then
  echo "Starting kalan ADMIN MODE"
  chown -R kcontainer:kcontainer /var/kalan-container/k-w2p/applications/
  exec /usr/bin/python /var/kalan-container/k-w2p/web2py.py --nogui -i 0.0.0.0 -p 8443 -a "$par2" -k $container_sslfolder/self_signed.key -c $container_sslfolder/self_signed.cert

fi

exec "$@"
