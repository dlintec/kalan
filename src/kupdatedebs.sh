#! /bin/bash
KALAN_DIR="$HOME/kalan"

 if [ ! -d KALAN_DIR-data/downloads/debs ];then
    mkdir -p KALAN_DIR-data/downloads/debs
 fi
 dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > KALAN_DIR-data/result-all-apt-get.fil
 
 cd KALAN_DIR-data/downloads/debs
 dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
 
