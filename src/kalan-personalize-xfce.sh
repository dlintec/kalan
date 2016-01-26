#!/bin/bash
KALAN_DIR="$HOME/kalan"
backdropfolder="/usr/share/xfce4/backdrops"
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan

sudo cp -a $KALAN_DIR/media/wallpapers/. $backdropfolder/
sudo mv -f /usr/share/backgrounds/xfce/xfce-blue.jpg $backdropfolder/xfce-blue-ant.jpg
sudo ln -sf /usr/share/backgrounds/xfce/kalan-blue.jpg $backdropfolder/kalan-blue.jpg
sudo chmod -R 755 $backdropfolder

sudo chmod -R 755 /usr/local/share/kalan

mkdir -p  $HOME/.config/resp-autostart
mkdir -p ~/.local/share/applications
#cp -a $HOME/.config/autostart/. $HOME/.config/resp-autostart/
#rm -rf $HOME/.config/autostart/*.desktop 
#cp -rf $KALAN_DIR/sw/autostart/*.desktop $HOME/.config/autostart/

sudo cp -rf  $KALAN_DIR/sw/plank $HOME/.config/

sudo cp -a $KALAN_DIR/sw/lubuntu/wallpapers/*.* /usr/share/backgrounds
if [[ ! -d /lib/plymouth/themes/xubuntu-logo-orig ]];then
  sudo cp -rf /lib/plymouth/themes/xubuntu-logo /lib/plymouth/themes/xubuntu-logo-orig
fi

sudo cp -a $KALAN_DIR/sw/plymouth/themes/. /lib/plymouth/themes
sudo cp -rf /lib/plymouth/themes/xubuntu-logo/wallpaper.png /usr/share/xfce4/backdrops/xubuntu-trusty.png
#sudo dpkg -i $KALAN_DIR/sw/plymouth/plymouth-manager_1.5.0-1_all.deb
sudo chmod -R 644 /lib/plymouth/themes/xubuntu-logo
sudo chmod -R 755 /usr/share/backgrounds
sudo chown -R root:root /usr/share/backgrounds
sudo chown -R root:root /lib/plymouth/themes
sudo update-initramfs -k all -u
#gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/kalan-blue.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop


#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
#In pcmanfm preferences, under the advanced tab, change the terminal to "x-terminal-emulator -e %s". You can also change the "terminal" value in ~/.config/libfm/libfm.conf.
#sudo update-desktop-database
sudo gtk-update-icon-cache /usr/share/icons/Faenza/
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Ambiance/
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Dark/
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Darker/
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Darkest/
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Radiance/
sudo gtk-update-icon-cache /usr/share/icons/Faba/
sudo gtk-update-icon-cache /usr/share/icons/Moka/

sudo cp -f $KALAN_DIR/sw/lxde/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
