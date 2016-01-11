#!/bin/bash
main() {
source ~/kalan/src/kalan-lib.sh

cd /var/
if [ ! -e ~/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git ~/kalan
fi
cd ~/kalan
git pull
chmod -R 770 ~/kalan/src
chmod +x ~/kalan/src/kalan.sh
chmod +x ~/kalan/src/kregisterscript.sh
chmod +x ~/kalan/src/kregisterscriptsfolder.sh

~/kalan/src/kregisterscriptsfolder.sh
}

main "$@"
