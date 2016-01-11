#!/bin/bash
source ~/kalan/src/kalan-lib.sh
KALAN_DIR="$HOME/kalan"
PACKAGE_MANAGER=$(get_package_manager)
current_dir=`pwd`
cd $KALAN_DIR/sw/bashgui
sudo make install
$KALAN_DIR/src/kalan-core-$PACKAGE_MANAGER.sh
echo "DONE:kalan-install-core" >> $KALAN_DIR-data/conf/flag_install
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-core-$PACKAGE_MANAGER.fil
cd $current_dir
