#!/bin/bash
#Update 5: This update will install new docker version and create new images for "containerized" meteor/nodejs . Also reconfigures firewall to forward docker's virtual network. Container Image creation may take from 10 to 20 minutes depending on your bandwidth. Be patient...
KALAN_DIR="$HOME/kalan"

sudo usermod -aG docker ${USER}
sudo usermod -aG sudo ${USER}
kalan-stop
kalan-clean-docker
rm -f $KALAN_DIR-data/provisions/kalan/images/*
rm -rf $KALAN_DIR-data/provisions/kalan/mongo
#kalan-install-meteor
sudo service docker stop
kalan-install-docker
sudo service docker start
kalan-autostart

echo "Finished"
