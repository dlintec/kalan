param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="/home/$KALAN_USER/kalan"

if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi

cd $KALAN_DIR-data/downloads
atom_ver="v1.3.3"
if [[ ! -e $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver ]];then
    wget https://atom-installer.github.com/$atom_ver/atom-amd64.deb
    mv $KALAN_DIR-data/downloads/atom-amd64.deb $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver

fi
sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme/Numix /usr/share/icons/
sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme/Numix-Light /usr/share/icons/
sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme-circle/Numix-Circle /usr/share/icons/
sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme-circle/Numix-Circle-Light /usr/share/icons/
sudo cp -rf $KALAN_DIR/sw/icons/Uniform /usr/share/icons/

#dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2
#https://atom.io/
if [[ "$param1" == "--sudo" ]];then
   sudo dpkg -i $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
   sudo apt-get install xfce4 synaptic
   sudo apt-get install system-config-kickstart aptitude unity-tweak-tool
fi
