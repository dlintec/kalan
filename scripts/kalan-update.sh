#!/bin/bash
source /opt/kalan/scripts/kalan-lib.sh

cd /opt/
if [ ! -e /opt/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
fi
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod +x /opt/kalan/kalan-setup.sh
chmod -R 770 /opt/kalan/scripts
