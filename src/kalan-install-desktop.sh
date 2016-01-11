#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi
cd $KALAN_DIR-data/downloads

git clone --recursive https://github.com/moka-project/faba-icon-theme.git
cd $KALAN_DIR-data/downloads/faba-icon-theme
git pull
sudo cp -rf $KALAN_DIR-data/downloads/faba-icon-theme/Faba /usr/share/icons/Faba

cd $KALAN_DIR-data/downloads
git clone --recursive https://github.com/moka-project/moka-icon-theme.git
cd $KALAN_DIR-data/downloads/moka-icon-theme
git pull

sudo cp -rf $KALAN_DIR-data/downloads/moka-icon-theme/Moka /usr/share/icons/Moka

atom_ver="v1.3.3"
if [[ ! -e $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver ]];then
    wget https://atom-installer.github.com/$atom_ver/atom-amd64.deb
    mv $KALAN_DIR-data/downloads/atom-amd64.deb $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
    sudo dpkg -i $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
fi




sudo apt-get -y install xfce4 synaptic aptitude unity-tweak-tool

sudo apt-get -y install ufw gufw quickly 
sudo apt-get -y install build-essential debhelper devscripts libblkid-dev libmount-dev libncursesw5-dev libparted0-dev qtbase5-dev qttools5-dev-tools
#install calibre
#sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#wget https://github.com/aptana/studio3/releases/download/v3.6.1/Aptana_Studio_3_Setup_Linux_x86_64_3.6.1.zip

if ! [ -x "$(command -v systemback-cli)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   systemback is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install systemback"
  echo "-------------------------------------------------------------------------"
  cd $KALAN_DIR/sw/sb/systemback
  sudo debuild
fi


#sudo apt-get -y install blender mypaint gimp scribus openshot avidemux  darktable inkscape virtualbox


dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-desktop-apt-get.fil
#dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/desktop-apt-get.fil
#https://atom.io/
echo
echo "Kalan desktop workstation installed."
echo
