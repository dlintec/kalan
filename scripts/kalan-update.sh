#!/bin/bash
main() {
source /var/kalan/scripts/kalan-lib.sh

cd /var/
if [ ! -e /var/kalan/README.md ];then
   git clone --recursive https://github.com/dlintec/kalan.git /var/kalan
fi
cd /var/kalan
git fetch origin
git reset --hard origin/master
git pull
chmod -R 770 /var/kalan/scripts
chmod +x /var/kalan/scripts/kalan.sh
chmod +x /var/kalan/scripts/kregisterscript.sh
chmod +x /var/kalan/scripts/kregisterscriptsfolder.sh

/var/kalan/scripts/kregisterscriptsfolder.sh
}

main "$@"
