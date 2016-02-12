#!/bin/bash
KALAN_DIR="$HOME/kalan"
pprovision="$1"
cp -rf $KALAN_DIR/dockerfiles/kalan/k-meteor/files $KALAN_DIR-data/provisions/kalan/met/
cp -rf $KALAN_DIR/dockerfiles/kalan/k-meteor/start.json $KALAN_DIR-data/provisions/kalan/met/start.json

krefreshmeteor

