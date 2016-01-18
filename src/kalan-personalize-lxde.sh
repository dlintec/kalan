#!/bin/bash
KALAN_DIR="$HOME/kalan"

sudo cp -rf $KALAN_DIR/media/kalan-gray.* /usr/local/share/kalan
chmod -R 755 /usr/local/share/kalan
#gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/kalan/kalan-gray.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop

sudo cat << 'EOF' > /etc/lightdm/lightdm-gtk-greeter.conf
#
# logo = Logo file to use, either an image absolute path, or a path relative to the greeter data directory
# background = Background file to use, either an image path or a color (e.g. #772953)
# theme-name = GTK+ theme to use
# icon-theme-name = Icon theme to use
# font-name = Font to use
# xft-antialias = Whether to antialias Xft fonts (true or false)
# xft-dpi = Resolution for Xft in dots per inch (e.g. 96)
# xft-hintstyle = What degree of hinting to use (none, slight, medium, or full)
# xft-rgba = Type of subpixel antialiasing (none, rgb, bgr, vrgb or vbgr)
# show-language-selector (true or false)
# show-indicators = semi-colon ";" separated list of allowed indicator modules (e.g. libsoundmenu.so)
# show-clock (true or false)
# clock-format = strftime-format string, e.g. %H:%M
# keyboard = command to launch on-screen keyboard
#
[greeter]
logo=/usr/share/icons/lubuntu/places/64/start-here.svg
background=/usr/local/share/kalan/kalan-gray.png
theme-name=Lubuntu-default
icon-theme-name=lubuntu
font-name=Ubuntu
xft-antialias=true
#xft-dpi=
xft-hintstyle=full
xft-rgba=rgb
show-language-selector=true
#show-clock=
#clock-format=
keyboard=onboard

EOF
