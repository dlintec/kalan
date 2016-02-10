#!/bin/bash
par1="$1"
par2="$2"
par3="$3"

set -e
startapp="start"
command="$@"
case "$par1" in
  start)
    startapp="$par2"
    command="meteor"
  ;;
  create)
    startapp="$par2"
    command="echo 'app created'"
  ;;
  *)
    command="$@"
  ;;
esac       

if [[ (! -n "$startapp" ) ]];then
   startapp="start"
fi
if [[ (! -d "/opt/application/$startapp" ) ]]; then
    cd /opt/application
    meteor create $startapp
fi
cd /opt/application/$startapp


exec "$command"

