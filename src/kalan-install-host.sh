#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
echo "User: $KALAN_USER"
if id -u "kalan" >/dev/null 2>&1; then
   echo "user kalan already created"
else
   echo "Creating user kalan."
           useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
           if [ ! -e /home/$KALAN_USER/kalan-data/conf/kalan.conf ];then
           kalan_hash=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16)
           #####SCRIPT##### kalan.conf
cat << EOF > /home/$KALAN_USER/kalan-data/conf/kalan.conf
VERSION_ORIGINAL=$KALAN_VERSION
VERSION_ACTUAL=$KALAN_VERSION
URL_ACTUALIZACION=https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh
DESTINO_PROXY_DEFAULT=http://localhost:8888
KALANPG_MD5=$kalan_hash
PACKAGE_MANAGER=$PACKAGE_MANAGER
EOF
           #####ENDSCRIPT##### kalan.conf
           fi
           source /home/$KALAN_USER/kalan/src/kalan-lib.sh
           replaceLinesThanContain "VERSION_ACTUAL" "VERSION_ACTUAL=$KALAN_VERSION" /home/$KALAN_USER/kalan-data/conf/kalan.conf


fi


/home/$KALAN_USER/kalan/src/kalan-install-core.sh
/home/$KALAN_USER/kalan/src/kalan-install-docker.sh
sudo chown -R $KALAN_USER:$KALAN_USER /home/$KALAN_USER/kalan
sudo chgrp -R $KALAN_USER /home/$KALAN_USER/kalan-data
sudo chmod -R 771 /home/$KALAN_USER/kalan
sudo chmod -R 771 /home/$KALAN_USER/kalan-data


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
