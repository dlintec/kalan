#!/bin/bash
KALAN_DIR="$HOME/kalan"
backdropfolder="/usr/share/xfce4/backdrops"
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan

sudo cp -a $KALAN_DIR/media/wallpapers/. $backdropfolder/
sudo mv -rf /usr/share/backgrounds/xfce/xfce-blue.jpg $backdropfolder/xfce-blue-ant.jpg
sudo ln -sf /usr/share/backgrounds/xfce/kalan-blue.jpg $backdropfolder/kalan-blue.jpg
sudo chmod -R 755 $backdropfolder

sudo chmod -R 755 /usr/local/share/kalan

mkdir -p  $HOME/.config/resp-autostart
mkdir -p ~/.local/share/applications
#cp -a $HOME/.config/autostart/. $HOME/.config/resp-autostart/
#rm -rf $HOME/.config/autostart/*.desktop 
#cp -rf $KALAN_DIR/sw/autostart/*.desktop $HOME/.config/autostart/

sudo cp -rf  $KALAN_DIR/sw/plank $HOME/.config/


#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
#In pcmanfm preferences, under the advanced tab, change the terminal to "x-terminal-emulator -e %s". You can also change the "terminal" value in ~/.config/libfm/libfm.conf.
sudo update-desktop-database

sudo cp -f $KALAN_DIR/sw/lxde/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
