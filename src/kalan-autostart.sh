#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
export supermode="dialog" && source easybashgui

kprovision kalan --remove
clear
kecho "Welcome $KALAN_USER"
kprovision kalan --admin admin
