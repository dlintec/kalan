#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e
if [[ ( ! -d /opt/application/private ) ]];then
  cd /opt
  meteor create application
  cd application 
fi
cd /opt/application

exec "$@"
