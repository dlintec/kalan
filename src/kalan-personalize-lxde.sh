#!/bin/bash
KALAN_DIR="$HOME/kalan"
sudo apt-get install lm-sensors
sudo apt-get install conky-all
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
sudo cp -rf $KALAN_DIR/media/plymouth/*.* /lib/plymouth/themes/lubuntu-logo
sudo chmod -R 755 /usr/local/share/kalan
#gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/kalan/kalan-gray.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop


sudo cp -f $KALAN_DIR/sw/lxde/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
