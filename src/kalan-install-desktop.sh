#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#sudo cp -rf $KALAN_DIR/media/kalan-gray.png /usr/share/backgrounds/kalan-gray.png
gsettings set org.gnome.desktop.background picture-uri file://$KALAN_DIR/media/kalan-gray.png

if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi
if [[ ! -d $KALAN_DIR-data/build ]];then
    mkdir -p $KALAN_DIR-data/build
fi
if [[ -d $KALAN_DIR-data/archives ]];then
    onlyinarchives=$(comm -23 <(ls $KALAN_DIR-data/archives |sort) <(ls /var/cache/apt/archives|sort))
    for line in $onlyinarchives ; do 
            echo "$line" 
            
            echo "Copying $line new from archives"
            sudo cp -rf $KALAN_DIR-data/archives/$line /var/cache/apt/archives/$line
            sudo dpkg -i $KALAN_DIR-data/archives/$line 
    done 
    sudo apt-get -f install
fi

cd $KALAN_DIR-data/downloads

git clone --recursive https://github.com/moka-project/faba-icon-theme.git
cd $KALAN_DIR-data/downloads/faba-icon-theme
git pull
#sudo cp -rf $KALAN_DIR-data/downloads/faba-icon-theme/Faba /usr/share/icons/Faba
sudo rsync -aAXv $KALAN_DIR-data/downloads/faba-icon-theme/Faba/* /usr/share/icons/Faba

cd $KALAN_DIR-data/downloads
git clone --recursive https://github.com/moka-project/moka-icon-theme.git
cd $KALAN_DIR-data/downloads/moka-icon-theme
git pull
#sudo cp -rf $KALAN_DIR-data/downloads/moka-icon-theme/Moka /usr/share/icons/Moka
sudo rsync -aAXv $KALAN_DIR-data/downloads/moka-icon-theme/Moka/* /usr/share/icons/Moka

sudo apt-get -y install xfce4 synaptic aptitude unity-tweak-tool

sudo apt-get -y install ufw gufw quickly lupin-casper squashfs-tools
sudo apt-get -y install build-essential debhelper devscripts libblkid-dev libmount-dev libncursesw5-dev libparted0-dev qtbase5-dev qttools5-dev-tools


dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-desktop-apt-get.fil

#dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/desktop-apt-get.fil
#https://atom.io/
echo
echo "Kalan desktop workstation installed."
echo
