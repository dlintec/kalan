#!/bin/bash
par1="$1"
par2="$2"
par3="$3"

set -e
startapp="start"
command="$@"
if [[ ("$par1" == "start") ]];then
 
  if [[ ( -n "$par2" ) ]];then
      startapp="$par2"
  fi
  if [[ (! -d "/opt/application/$startapp" ) ]]; then
    cp -f /opt/start.json /opt/application/start.json
    cd /opt/application
    meteor-kitchen /opt/application/start.json /opt/application/$startapp
  fi
  cd /opt/application/$startapp
  exec meteor
else
  exec "$@"
fi


