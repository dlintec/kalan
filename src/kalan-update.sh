#!/bin/bash
main() {
   
echo "$0"
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#sudo cp -rf $KALAN_DIR/media/kalan-gray.png /usr/share/backgrounds/kalan-gray.png
echo "We need your superuser powers to start services"
sudo echo "If sudo succeds your are in..."

source $KALAN_DIR/src/kalan-lib.sh

current_dir=`pwd`
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
PACKAGE_MANAGER="yum"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACKAGE_MANAGER=${osInfo[$f]}
        echo $PACKAGE_MANAGER
    fi
done 
#$PACKAGE_MANAGER -y install git curl
if ! [ -x "$(command -v git)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   Git is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install git"
  echo "-------------------------------------------------------------------------"
 
  sudo apt-get -y install git
  echo "   Git installed: "
  echo "   curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i"
  echo
fi
if [ -n "$(command -v git)" ]; then
   cd /var/
   if [ ! -e $KALAN_DIR/README.md ];then
      git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
   fi
   cd $KALAN_DIR
   git fetch --all
   git reset --hard origin/master
   git pull
   chmod -R 770 $KALAN_DIR/src
   chmod +x $KALAN_DIR/src/kalan.sh
   chmod +x $KALAN_DIR/src/kregisterscript.sh
   chmod +x $KALAN_DIR/src/kregisterscriptsfolder.sh
   chmod -R 775 $KALAN_DIR/media
   
   
   $KALAN_DIR/src/kregisterscriptsfolder.sh
   if [[ ! -d /usr/local/share/kalan ]];then
     sudo mkdir -p /usr/local/share/kalan
   fi
   if [[ ! -d ~/bin ]];then
     mkdir -p ~/bin
   fi
   sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
   
   sudo cp -a $KALAN_DIR/sw/lubuntu/wallpapers/*.* /usr/share/backgrounds
   sudo chmod -R 755 /usr/share/backgrounds
   sudo chmod -R 755 $KALAN_DIR/src/kalan-update.sh
   sudo chown -R root:root /usr/share/backgrounds
   sudo cp -a $KALAN_DIR/sw/*.desktop /usr/share/applications/
   sudo chmod -R 755 /usr/share/applications/kalan-update.desktop
   sudo cp -a /usr/share/applications/kalan-update.desktop $HOME/Desktop/
   sudo chmod -R 755 $HOME/Desktop/kalan-update.desktop
   sudo cp -a $KALAN_DIR/src/kalan-update.sh /usr/local/bin/
   gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/kalan-blue.jpg

else
   echo
   echo "  You need to install 'git' to download kalan"
fi

}

main "$@"
