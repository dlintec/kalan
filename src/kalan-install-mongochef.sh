#!/bin/bash
KALAN_DIR="$HOME/kalan" 
current_dir=`pwd` 
echo "installing mongochef..."
cd $KALAN_DIR-data/downloads
wget https://cdn.3t.io/mongochef/linux/3.4.1/mongochef-linux-x64-dist.tar.gz
tar -xvzf mongochef-linux-x64-dist.tar.gz
./mongochef-3.4.1-linux-x64-dist/bin/mongochef.sh

