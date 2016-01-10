#!/bin/bash
source ~/kalan/src/kalan-lib.sh
KALAN_DIR="$HOME/kalan"
PACKAGE_MANAGER=$(get_package_manager)
current_dir=`pwd`
cd $KALAN_DIR/sw/bashgui
sudo make install
$KALAN_DIR/src/kalan-core-$PACKAGE_MANAGER.sh
echo "DONE:kalan-install-core" >> $KALAN_DIR-data/conf/flag_install
cd $current_dir
