#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
source ~/kalan/src/kalan-lib.sh
#export supermode="dialog" && source easybashgui
source easybashgui
kecho "Welcome $KALAN_USER"
sudo echo "  we need your superuser powers to start services"
kprovision kalan --remove
clear
kecho "Welcome $KALAN_USER"
kprovision kalan --admin admin

#wait_seconds 10
#exec x-www-browser https://localhost:8443
clear
kecho "Connect with your browser to https://localhost:8443"
echo "  This system also has the following IPs:"
echo ""
get-ip-address
echo "Press enter to close this window"
read CONFIRM
