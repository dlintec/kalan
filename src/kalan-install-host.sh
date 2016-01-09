#!/bin/bash

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="/home/$KALAN_USER/kalan"
echo "User: $KALAN_USER"
current_dir=`pwd`
if id -u "kalan" >/dev/null 2>&1; then
   echo "user kalan already created"
else
   echo "Creating user kalan."
           useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
           if [ ! -e $KALAN_DIR-data/conf/kalan.conf ];then
               if [ ! -d $KALAN_DIR-data/conf/ ]; then
                   mkdir -p $KALAN_DIR-data/conf/
               fi

               kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
               #####SCRIPT##### kalan.conf
cat << EOF > $KALAN_DIR-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
PACKAGE_MANAGER=$PACKAGE_MANAGER
EOF
              #####ENDSCRIPT##### kalan.conf
           fi
           source $KALAN_DIR/src/kalan-lib.sh
           replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" $KALAN_DIR-data/conf/kalan.conf

fi

cd $KALAN_DIR/sw/bashgui
sudo make install
$KALAN_DIR/src/kalan-install-core.sh
$KALAN_DIR/src/kalan-install-docker.sh
sudo chmod -R 771 $KALAN_DIR
sudo chmod -R 771 $KALAN_DIR-data
cd $current_dir

#git config --global user.name "John Doe"
#git config --global user.email johndoe@example.com
#git config user.name "Billy Everyteen"
#git config user.email johndoe@example.com
#git remote rm origin
#git remote add origin https://github.com/dlintec/kalan.git
#git push https://github.com/dlintec/kalan.git
#git init
#git add README.md
#git commit -m "first commit"


#git remote add origin https://github.com/<username>/dlintec/kalan.git
#git push --set-upstream origin master
