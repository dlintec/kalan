#!/bin/bash
#-
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
#export supermode="dialog" && source easybashgui
source easybashgui
$KALAN_DIR/src/kalan-stop.sh


# for migration purposes of legacy apps
if [[ ( -d $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications ) ]];then
  echo "Rebuilding and migrating from update"
  provision_image_folder=$KALAN_DIR-data/provisions/kalan/data
  mkdir -p $provision_image_folder/applications
  sudo cp -a $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications/. $provision_image_folder/applications/
  sudo chown -R 999:999 $provision_image_folder/applications
  if [[ ( -d $provision_image_folder/applications/dlintec ) ]];then
       sudo rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container
  fi
fi
rm -rf $KALAN_DIR-data/docker-images
##
$KALAN_DIR/src/kalan-stop.sh
$KALAN_DIR/src/kprovision kalan --remove
$KALAN_DIR/src/kalan-clean-docker.sh

$KALAN_DIR/src/kalan-autostart.sh
echo "Update Finished"
