#!/bin/bash
KALAN_DIR="$HOME/kalan"
$KALAN_DIR/src/kalan-install-xfce.sh
$KALAN_DIR/src/kalan-install-host.sh
$KALAN_DIR/src/kalan-install-desktop.sh
$KALAN_DIR/src/kalan-install-apps-00.sh
$KALAN_DIR/src/kalan-install-apps-01.sh
$KALAN_DIR/src/kalan-install-touch.sh
$KALAN_DIR/src/kalan-personalize-xfce.sh

sudo update-initramfs -k all -u
rm -f ~/kalan-install-all
$KALAN_DIR/src/kalan-install-mongochef.sh
echo "-----------------------------------------------------"
echo "  Select the widgets you want to appear in your desktop from conky-manager"
echo "  Selecciona los elementos de monitoreo en conky manager. "
$KALAN_DIR/src/kalan-install-conky.sh
echo "Finished"
