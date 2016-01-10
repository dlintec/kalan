param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi

cd $KALAN_DIR-data/downloads
atom_ver="v1.3.3"
if [[ ! -e $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver ]];then
    wget https://atom-installer.github.com/$atom_ver/atom-amd64.deb
    mv $KALAN_DIR-data/downloads/atom-amd64.deb $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
    sudo dpkg -i $KALAN_DIR-data/downloads/atom-amd64.deb.$atom_ver
fi


if ! [ -x "$(command -v systemback-cli)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   systemback is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install systemback"
  echo "-------------------------------------------------------------------------"
  sudo add-apt-repository ppa:nemh/systemback
  sudo apt-get -y update
  sudo apt-get -y install systemback
fi



sudo apt-get -y install xfce4 synaptic glade aptitude unity-tweak-tool


cd $KALAN_DIR-data/downloads
git clone --recursive https://github.com/moka-project/faba-icon-theme.git
cd $KALAN_DIR-data/downloads/moka-project
git pull
sudo cp -rf $KALAN_DIR-data/downloads/faba-icon-theme/Faba /usr/share/icons/Faba

cd $KALAN_DIR-data/downloads
git clone --recursive https://github.com/moka-project/moka-icon-theme.git
cd $KALAN_DIR-data/downloads/moka-project
git pull
bash autogen.sh
make
sudo make install

cp /usr/share/icons/Faba cd $KALAN_DIR-data/downloads/Faba
cp /usr/share/icons/Moka cd $KALAN_DIR-data/downloads/Moka

cd $current_dir


#sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme/Numix /usr/share/icons/
#sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme/Numix-Light /usr/share/icons/
#sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme-circle/Numix-Circle /usr/share/icons/
#sudo cp -rf $KALAN_DIR/sw/icons/numix-icon-theme-circle/Numix-Circle-Light /usr/share/icons/
#sudo cp -rf $KALAN_DIR/sw/icons/Uniform /usr/share/icons/

dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/desktop-apt-get.fil
#https://atom.io/
