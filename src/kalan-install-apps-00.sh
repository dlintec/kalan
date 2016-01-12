#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`

#sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#wget https://github.com/aptana/studio3/releases/download/v3.6.1/Aptana_Studio_3_Setup_Linux_x86_64_3.6.1.zip

if ! [ -x "$(command -v systemback-cli)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   systemback is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install systemback"
  echo "-------------------------------------------------------------------------"
  sudo apt-get -y install lupin-casper squashfs-tools
fi

if [[ ! -e $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb ]];then
    cp -rf $KALAN_DIR/sw/sb $KALAN_DIR-data/build/sb
    cd $KALAN_DIR-data/build/sb/systemback
    
    #tar xpvf /path/to/my_archive.tar.xz -C /path/to/extract
    sudo debuild
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-locales_1.7.301_all.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-cli_1.7.301_amd64.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-efiboot-amd64_1.7.301_all.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-scheduler_1.7.301_amd64.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/libsystemback_1.7.301_amd64.deb /var/cache/apt/archives
    
    sudo cp -f $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb /var/cache/apt/archives
    
    sudo dpkg -i $KALAN_DIR-data/build/sb/libsystemback_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-locales_1.7.301_all.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-cli_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-efiboot-amd64_1.7.301_all.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-scheduler_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-cli_1.7.301_amd64.deb
    sudo apt-get -f install
fi



#sudo apt-get -y install blender mypaint gimp scribus openshot avidemux  darktable inkscape virtualbox
