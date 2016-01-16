#!/bin/bash
main() {
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#sudo cp -rf $KALAN_DIR/media/kalan-gray.png /usr/share/backgrounds/kalan-gray.png


source $KALAN_DIR/src/kalan-lib.sh

cd /var/
if [ ! -e $KALAN_DIR/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
fi
cd $KALAN_DIR
git fetch --all
git reset --hard origin/master
git pull
chmod -R 770 $KALAN_DIR/src
chmod +x $KALAN_DIR/src/kalan.sh
chmod +x $KALAN_DIR/src/kregisterscript.sh
chmod +x $KALAN_DIR/src/kregisterscriptsfolder.sh
chmod 775 $KALAN_DIR/media

chmod 775 $KALAN_DIR/media/kalan-gray.png
chmod 775 $KALAN_DIR/media/kalan-gray.jpg
$KALAN_DIR/src/kregisterscriptsfolder.sh
if [[ ! -d /usr/local/share/kalan ]];then
  mkdir -p /usr/local/share/kalan
fi
cp -rf $KALAN_DIR/media/kalan-gray.* /usr/local/share/kalan
gsettings set org.gnome.desktop.background picture-uri file://$KALAN_DIR/media/kalan-gray.jpg
#sudo cp -rf $KALAN_DIR/src/kalan-update.sh /usr/local/bin/kalan-update.sh
}

main "$@"
