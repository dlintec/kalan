#!/bin/bash
KALAN_DIR="$HOME/kalan"
cat << EOFKALANSCRIPT > $HOME/.config/autostart/kalan-autostart.desktop
[Desktop Entry]
Type=Application
Exec="$KALAN_DIR/src/kalan-autostart.sh"
Hidden=false
Terminal=true
Name=kalan-autostart

Comment=Startin containers
EOFKALANSCRIPT
