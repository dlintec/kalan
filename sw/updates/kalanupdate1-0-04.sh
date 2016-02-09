#!/bin/bash
#Update 4: This update installs new docker version, installs meteor and creates new images for "containerized" meteor app. Also reconfigures firewall to forward docker's virtual network. Container Images must be recreated so this may take from 10 to 20 minutes depending on your bandwidth. 
KALAN_DIR="$HOME/kalan"

sudo usermod -aG docker ${USER}
sudo usermod -aG sudo ${USER}
kalan-stop
kalan-clean-docker
rm -f $KALAN_DIR-data/provisions/kalan/images/*
rm -rf $KALAN_DIR-data/provisions/kalan/mongo
kalan-install-meteor
sudo service docker stop
kalan-install-docker
sudo service docker start
kalan-autostart
kalan-install-conky
echo "Finished"
