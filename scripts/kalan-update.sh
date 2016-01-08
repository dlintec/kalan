#!/bin/bash
main() {
source ~/kalan/scripts/kalan-lib.sh

cd /var/
if [ ! -e ~/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git ~/kalan
fi
cd ~/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod -R 770 ~/kalan/scripts
chmod +x ~/kalan/scripts/kalan.sh
chmod +x ~/kalan/scripts/kregisterscript.sh
chmod +x ~/kalan/scripts/kregisterscriptsfolder.sh

~/kalan/scripts/kregisterscriptsfolder.sh
}

main "$@"
