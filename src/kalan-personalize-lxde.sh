#!/bin/bash
KALAN_DIR="$HOME/kalan"

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
mkdir -p  $HOME/.config/resp-autostart
mkdir -p ~/.local/share/applications
cp -a $HOME/.config/autostart/. $HOME/.config/resp-autostart/
rm -rf $HOME/.config/autostart/*.desktop 
cp -rf $KALAN_DIR/sw/autostart/*.desktop $HOME/.config/autostart/
sudo cp -rf  $KALAN_DIR/sw/lubuntu-logout.desktop /usr/share/applications/
sudo cp -rf  $KALAN_DIR/sw/plank $HOME/.config/

sudo chown root:root /usr/share/applications/lubuntu-logout.desktop 
sudo chmod  644 /usr/share/applications/lubuntu-logout.desktop
#sudo chmod +x  /usr/share/applications/lubuntu-logout.desktop
#gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/kalan/kalan-gray.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
#In pcmanfm preferences, under the advanced tab, change the terminal to "x-terminal-emulator -e %s". You can also change the "terminal" value in ~/.config/libfm/libfm.conf.
sudo update-desktop-database

sudo cp -f $KALAN_DIR/sw/lxde/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
