#!/bin/bash
KALAN_DIR="$HOME/kalan"
pprovision="$1"
pimage="$2"
ptag="$3"
if [[ ( -n "$ptag" ) ]];then
  ptag="latest"
fi
docker save --output $KALAN_DIR-data/provisions/$pprovision/images/$pimage.tar $pimage:$ptag
RESULT=$?
return $RESULT
