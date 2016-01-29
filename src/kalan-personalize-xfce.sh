#!/bin/bash
KALAN_DIR="$HOME/kalan"
backdropfolder="/usr/share/xfce4/backdrops"
sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
sudo rm -f $backdropfolder/*.png
sudo rm -f $backdropfolder/*.jpg
sudo cp -a -L $KALAN_DIR/media/wallpapers/. $backdropfolder/
sudo cp -f  $backdropfolder/kalan-gray.jpg /usr/share/backgrounds/xfce/xfce-blue.jpg
sudo cp -f  "$backdropfolder/kalan mundo.png" $backdropfolder/xubuntu-trusty.png

sudo chmod -R 755 $backdropfolder

sudo chmod -R 755 /usr/local/share/kalan

mkdir -p  $HOME/.config/resp-autostart
mkdir -p ~/.local/share/applications
#cp -a $HOME/.config/autostart/. $HOME/.config/resp-autostart/
#rm -rf $HOME/.config/autostart/*.desktop 
$KALAN_DIR/src/kconfigautostart.sh

cp -a  $KALAN_DIR/sw/plank/. $HOME/.config/plank
#chmod -R 755 $HOME/.config/plank

sudo cp -a $KALAN_DIR/sw/lubuntu/wallpapers/*.* /usr/share/backgrounds
if [[ ! -d /lib/plymouth/themes/xubuntu-logo-orig ]];then
  sudo cp -rf /lib/plymouth/themes/xubuntu-logo /lib/plymouth/themes/xubuntu-logo-orig
fi

sudo cp -a $KALAN_DIR/sw/plymouth/themes/. /lib/plymouth/themes
#sudo cp -rf /lib/plymouth/themes/xubuntu-logo/wallpaper.png /usr/share/xfce4/backdrops/xubuntu-trusty.png
#sudo dpkg -i $KALAN_DIR/sw/plymouth/plymouth-manager_1.5.0-1_all.deb
sudo chmod -R 644 /lib/plymouth/themes/xubuntu-logo
sudo chmod -R 755 /usr/share/backgrounds
sudo chmod -R 755 /lib/plymouth/themes
sudo chown -R root:root /usr/share/backgrounds
sudo chown -R root:root /lib/plymouth/themes
#sudo update-initramfs -k all -u
#gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/kalan-blue.jpg
#sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop

xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set /usr/share/backgrounds/kalan-gray.jpg

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

sudo cp -f $KALAN_DIR/sw/xfce/lightdm-gtk-greeter-conf /etc/lightdm/lightdm-gtk-greeter.conf
