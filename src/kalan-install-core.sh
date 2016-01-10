#!/bin/bash
source ~/kalan/src/kalan-lib.sh
PACKAGE_MANAGER=$(get_package_manager)
cd $KALAN_DIR/sw/bashgui
sudo make install
~/kalan/src/kalan-core-$PACKAGE_MANAGER.sh
echo "DONE:kalan-install-core" >> ~/kalan-data/conf/flag_install
