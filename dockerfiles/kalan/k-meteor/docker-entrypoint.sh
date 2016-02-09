#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e

if [[ ( -n "$par1" ) && ( -d "/opt/application/$par1" ) ]]; then
  cd /opt/application/$par1
else
  if [[ ( ! -d /opt/application/start ) ]];then
    echo "#if this file is missing meteor will create a new default app /opt/application/start" > /opt/application/.mustexist
    cd /opt/application
    meteor create start
  fi
  cd /opt/application/start
fi
exec "$@"
