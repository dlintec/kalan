param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="/home/$KALAN_USER"

if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi
cp -rf $KALAN_DIR/sw/icons/Numix-Circle /usr/share/icons/Numix-Circle
cp -rf $KALAN_DIR/sw/icons/Numix-Circle-Light /usr/share/icons/Numix-Circle-Light

cd $KALAN_DIR-data/downloads
atom_ver="v1.3.3"
if [[ ! -e $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver ]];then
    wget https://atom-installer.github.com/$atom_ver/atom-amd64.deb
    cp -rf $KALAN_DIR-data/downloads/atom-amd64.deb $KALAN_DIR-data/downloads/atom-amd64.deb$atom_ver

fi


#https://atom.io/
if [[ "$param1" != "--dry" ]];then
   sudo dpkg -i /atom-amd64.deb.$atom_ver
   sudo apt-get install xfce4
fi
