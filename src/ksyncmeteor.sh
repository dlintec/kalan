#!/bin/bash
KALAN_DIR="$HOME/kalan"
pprovision="$1"
cp -rf $KALAN_DIR/dockerfiles/kalan/k-meteor/files $KALAN_DIR-data/provisions/kalan/met/
sudo docker run -it kalan_meteor meteor-kitchen start.json start

