#!/bin/bash
KALAN_DIR="$HOME/kalan"
kprovision kalan --remove
kalan-clean-docker
sudo rm -rf $KALAN_DIR-data/downloads/*
sudo rm -rf $KALAN_DIR-data/build/*
sudo rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications/SG/errors
sudo rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications/SG/sessions
sudo rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications/dlintec/errors
sudo rm -rf $KALAN_DIR-data/provisions/kalan/kalan-container/k-w2p/applications/dlintec/sessions
rm -f $KALAN_DIR-data/conf/updates
echo "environment cleaned for clone"
