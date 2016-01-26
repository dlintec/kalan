#!/bin/bash
KALAN_DIR="$HOME/kalan"
$KALAN_DIR/src/kalan-install-host.sh
$KALAN_DIR/src/kalan-install-desktop.sh
$KALAN_DIR/src/kalan-install-apps-00.sh
$KALAN_DIR/src/kalan-install-apps-01.sh
$KALAN_DIR/src/kalan-install-touch.sh
$KALAN_DIR/src/kalan-install-xfce.sh
rm -f ~/kalan-install-all

