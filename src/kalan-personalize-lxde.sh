#!/bin/bash
KALAN_DIR="$HOME/kalan"
sudo apt-get -y install lm-sensors
sudo apt-get -y install conky-all
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
sudo cp -rf $KALAN_DIR/media/plymouth/*.* /lib/plymouth/themes/lubuntu-logo
sudo cp -a $KALAN_DIR/sw/lubuntu/. /usr/share/lubuntu
sudo chmod -R 644 /usr/share/lubuntu
sudo ln -sf /usr/share/lubuntu/wallpapers/kalan-blue.jpg /usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.jpg 
sudo ln -sf /usr/share/lubuntu/wallpapers/kalan-blue.jpg /usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png 
sudo chmod -R 644 /usr/local/share/kalan
sudo chmod -R 755 /usr/share/lubuntu
sudo chown -R root:root /usr/share/lubuntu
sudo update-initramfs -k all -u
#gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/kalan/kalan-gray.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop


sudo cp -f $KALAN_DIR/sw/lxde/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
