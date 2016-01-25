#!/bin/bash
KALAN_DIR="$HOME/kalan"
sudo add-apt-repository -y ppa:docky-core/stable

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install plank

sudo apt-get -y  autoremove
sudo apt-get -y install lubuntu-desktop
sudo apt-get -y install lm-sensors
sudo apt-get -y install conky-all
$KALAN_DIR/src/kalan-personalize-lxde.sh
