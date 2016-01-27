#!/bin/bash
KALAN_DIR="$HOME/kalan"
if [[ ! -d $HOME/.config/autostart ]];then
  mkdir $HOME/.config/autostart/
fi
rm -f $HOME/.config/autostart/kalan*.desktop
cp -rf $KALAN_DIR/sw/autostart/*.desktop $HOME/.config/autostart/

cat << EOFKALANSCRIPT > $HOME/.config/autostart/kalan-autostart.desktop
[Desktop Entry]
Type=Application
Exec="$KALAN_DIR/src/kalan-autostart.sh"
Hidden=false
Terminal=true
Name=kalan-autostart

Comment=Startin containers
EOFKALANSCRIPT
