#!/bin/bash
source ~/kalan/src/kalan-lib.sh
KALAN_DIR="$HOME/kalan"
PACKAGE_MANAGER=$(get_package_manager)
current_dir=`pwd`
cd $KALAN_DIR/sw/bashgui
sudo make install
~/kalan/src/kalan-core-$PACKAGE_MANAGER.sh
echo "DONE:kalan-install-core" >> ~/kalan-data/conf/flag_install
cd $current_dir
