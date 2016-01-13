#! /bin/bash
KALAN_DIR="$HOME/kalan"
 if [ ! -d KALAN_DIR-data/downloads/debs ];then
    mkdir -p KALAN_DIR-data/downloads/debs
 fi
 cd KALAN_DIR-data/downloads/debs
 dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
 
