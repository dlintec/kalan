#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e
if [[ ( ! -e /opt/application/.mustexist ) ]];then
  echo "#if this file is missing meteor will create a new default app /opt/application/start" > /opt/application/.mustexist
  cd /opt/application
  meteor create start
  cd start 
fi
cd /opt/application/start

exec "$@"
