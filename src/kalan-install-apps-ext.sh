#!/bin/bash 
 
 
KALAN_USER="$(who am i | awk '{print $1}')" 
KALAN_DIR="$HOME/kalan" 
source $KALAN_DIR/src/kalan-lib.sh 
PACKAGE_MANAGER=$(get_package_manager)  
current_dir=`pwd`  
addto
chromelist="/etc/apt/sources.list.d/google-chrome.list"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

if [ ! -e $chromelist ];then
    sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> $chromelist"
fi
if [[ -z $(grep "deb http://dl.google.com/linux/chrome/deb/ stable main" $chromelist) ]]; then  
    sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> $chromelist"
fi 
sudo apt-get update
sudo apt-get -y install google-chrome-unstable
sudo apt-get -y install virtualbox  

sudo add-apt-repository ppa:cairo-dock-team/ppa
sudo apt-get update
sudo apt-get install cairo-dock cairo-dock-plug-ins
