#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e
if [[ ( ! -e /opt/application/.mustexist ) ]];then
  echo "#if this file is missing meteor will create a new default app" > /opt/application/.mustexist
  cd /opt
  meteor create application
  cd application 
fi
cd /opt/application

exec "$@"
