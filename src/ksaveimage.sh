#!/bin/bash
KALAN_DIR="$HOME/kalan"
pprovision="$1"
pimage="$2"
ptag="$3"
if [[ ( -z "$ptag" ) ]];then
  ptag="latest"
fi
sudo docker save --output $KALAN_DIR-data/provisions/$pprovision/images/$pimage.tar $pimage
RESULT=$?
exit $RESULT
