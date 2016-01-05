#!/bin/bash
main() {
source /opt/kalan/scripts/kalan-lib.sh

cd /opt/
if [ ! -e /opt/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /opt/kalan
fi
cd /opt/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod -R 770 /opt/kalan/scripts
chmod +x /opt/kalan/scripts/kalan.sh
chmod +x /opt/kalan/scripts/kregisterscript.sh
chmod +x /opt/kalan/scripts/kregisterscriptsfolder.sh

/opt/kalan/kregisterscriptsfolder.sh
}

main "$@"
