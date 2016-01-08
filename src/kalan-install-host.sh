#!/bin/bash
KALAN_USER="$(who am i | awk '{print $1}')"
echo "User: $KALAN_USER"
if id -u "kalan" >/dev/null 2>&1; then
   echo "user kalan already created"
else
   echo "Creating user kalan."
           useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
fi


/home/$KALAN_USER/kalan/src/kalan-install-core.sh
/home/$KALAN_USER/kalan/src/kalan-install-docker.sh
sudo chown -R $KALAN_USER:$KALAN_USER /home/$KALAN_USER/kalan
sudo chgrp -R $KALAN_USER /home/$KALAN_USER/kalan-data
sudo chmod -R 771 /home/$KALAN_USER/kalan
sudo chmod -R 771 /home/$KALAN_USER/kalan-data
#git config user.name "Billy Everyteen"
#git config user.email johndoe@example.com
#git remote rm origin
#git remote add origin https://github.com/dlintec/kalan.git
#git push https://github.com/dlintec/kalan.git
