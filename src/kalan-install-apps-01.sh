#!/bin/bash 
param1="$1";shift 
KALAN_USER="$(who am i | awk '{print $1}')" 
KALAN_DIR="$HOME/kalan" 
current_dir=`pwd` 

atom_ver="v1.3.3"
if [[ ! -e $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver ]];then
    cd $KALAN_DIR-data/downloads
    wget https://atom-installer.github.com/$atom_ver/atom-amd64.deb
    mv $KALAN_DIR-data/downloads/atom-amd64.deb $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
fi

sudo dpkg -i $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
if  [ -d $KALAN_DIR-data/downloads/atom/packages ];then
   mkdir -p $HOME/.atom/packages
   cp -rf $KALAN_DIR-data/downloads/atom/packages/* $HOME/.atom/packages
fi

chromelist="/etc/apt/sources.list.d/google-chrome.list"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

if [[ -z $(grep "deb http://dl.google.com/linux/chrome/deb/ stable main" $chromelist) ]]; then  
   # sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> $chromelist"
   echo "adding google repository in false"
fi 
sudo apt-get update
sudo apt-get -y install google-chrome-unstable


sudo apt-get -y install blender mypaint gimp scribus openshot avidemux  darktable inkscape vlc browser-plugin-vlc

#sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#wget https://github.com/aptana/studio3/releases/download/v3.6.1/Aptana_Studio_3_Setup_Linux_x86_64_3.6.1.zip
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-apps-01-apt-get.fil

echo
echo "Finished."
echo
