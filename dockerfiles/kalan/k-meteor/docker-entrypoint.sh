#!/bin/bash
par1="$1"
par2="$2"
par3="$3"

set -e

if [[ ( -n "$par1" ) && ( -d "/opt/application/$par1" ) ]]; then
  cd /opt/application/$par1
else
  if [[ ( ! -d /opt/application/start ) ]];then
    cd /opt/application
    meteor create start
  fi
  cd /opt/application/start
fi
exec "meteor"
