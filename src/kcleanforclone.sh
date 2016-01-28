#!/bin/bash
KALAN_DIR="$HOME/kalan"
kprovision kalan --remove
kalan-clean-docker
rm -rf $KALAN_DIR-data/downloads/*
rm -rf $KALAN_DIR-data/build/*
echo "environment cleaned for clone"
