#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`

cd $KALAN_DIR
git fetch --all
git reset --hard origin/master
git pull
chmod -R 770 $KALAN_DIR/src
chmod +x $KALAN_DIR/src/kalan.sh
chmod +x $KALAN_DIR/src/kregisterscript.sh
chmod +x $KALAN_DIR/src/kregisterscriptsfolder.sh
chmod -R 775 $KALAN_DIR/media


if [[ ! -d /usr/local/share/kalan ]];then
 sudo mkdir -p /usr/local/share/kalan
fi
if [[ ! -d ~/bin ]];then
 mkdir -p ~/bin
fi
$KALAN_DIR/src/kregisterscriptsfolder.sh

cd $current_dir
