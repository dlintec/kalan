#!/bin/bash
par1="$1"
par2="$2"
par3="$3"
container_sslfolder="/var/kalan-container/ssl"
set -e
if [[ ( ! -d /opt/application/private ) ]];then
  cd /opt
  orion create application
  cd application 
fi


exec "$@"
