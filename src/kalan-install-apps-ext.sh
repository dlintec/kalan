#!/bin/bash 
 
 
KALAN_USER="$(who am i | awk '{print $1}')" 
KALAN_DIR="$HOME/kalan" 
source $KALAN_DIR/src/kalan-lib.sh 
PACKAGE_MANAGER=$(get_package_manager)  
current_dir=`pwd`  

chromelist="/etc/apt/sources.list.d/google-chrome.list"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

if [[ -z $(grep "deb http://dl.google.com/linux/chrome/deb/ stable main" $chromelist) ]]; then  
    sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> $chromelist"
fi 
sudo apt-get update
sudo apt-get -y install google-chrome-unstable
sudo apt-get -y install virtualbox  

sudo apt-get install g++ cmake qtbase5-dev libqt5x11extras5-dev libqt5svg5 libmuparser-dev
git clone --recursive https://github.com/ManuelSchneid3r/albert.git $KALAN_DIR-data/downloads/albert
cd $KALAN_DIR-data/downloads/albert
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make
sudo make install

sudo add-apt-repository ppa:docky-core/stable
sudo apt-get update
sudo apt-get install plank
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
