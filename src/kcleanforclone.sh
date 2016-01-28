#!/bin/bash
KALAN_DIR="$HOME/kalan"
kprovision kalan --remove
kalan-clean-docker
rm -rf $KALAN_DIR-data/downloads/*
rm -rf $KALAN_DIR-data/build/*
rm -f $KALAN_DIR-data/conf/updates
echo "environment cleaned for clone"
