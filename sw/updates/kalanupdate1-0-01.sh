#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
#export supermode="dialog" && source easybashgui
source easybashgui
$KALAN_DIR/src/kalan-stop.sh
$KALAN_DIR/src/kalan-personalize-xfce.sh
$KALAN_DIR/src/kconfigautostart.sh

# for migration purposes of legacy apps
if [[ ( -d $KALAN_DIR-data/provisions/kalan/kalan-container/web2py/applications ) ]];then
echo "Rebuilding and migrating from update"
  provision_image_folder=$KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p
  mkdir -p $provision_image_folder/applications
  sudo cp -a $KALAN_DIR-data/provisions/kalan/kalan-container/web2py/applications/. $provision_image_folder/applications/
  sudo chown -R 999:999 $provision_image_folder/applications
  rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container/web2py
fi
rm -f $KALAN_DIR-data/docker-images/k-w2p.tar
##

$KALAN_DIR/src/kbuildimage.sh k-w2p

$KALAN_DIR/src/kalan-autostart.sh
