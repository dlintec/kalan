#!/bin/bash
KALAN_DIR="$HOME/kalan"
sudo apt-get -y install touchegg  build-essential libqt4-dev libx11-6 onboard

git clone --recursive https://github.com/Raffarti/Touchegg-gce.git $KALAN_DIR-data/downloads/Touchegg-gce
cd $KALAN_DIR-data/downloads/Touchegg-gce
qmake
make
sudo cp -rf $KALAN_DIR-data/downloads/Touchegg-gce/touchegg-gce /usr/local/bin/touchegg-gce

#sudo sh VBoxLinuxAdditions.run virtualbox install tools
