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
chmod -R 775 $KALAN_DIR/media


$KALAN_DIR/src/kregisterscriptsfolder.sh
if [[ ! -d /usr/local/share/kalan ]];then
  sudo mkdir -p /usr/local/share/kalan
fi
if [[ ! -d ~/bin ]];then
  mkdir -p ~/bin
fi
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/kalan/kalan-glue.jpg

ln -sf ~/kalan/src/kalan-update.sh ~/kalan-update
ln -sf ~/kalan/src/kalan-update.sh ~/bin/kalan-update
}

main "$@"
