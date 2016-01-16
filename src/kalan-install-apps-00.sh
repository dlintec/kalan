#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

sudo add-apt-repository -y ppa:docky-core/stable
sudo apt-get update
sudo apt-get -y install plank

sudo apt-get -y install lupin-casper squashfs-tools
function _install_systemback () {
      echo "removing"
      sudo apt-get -y purge systemback
      sudo apt-get -y purge libsystemback
      sudo apt-get -y purge systemback-locales
      sudo apt-get -y purge systemback-cli
      sudo apt-get -y purge systemback-efiboot
      sudo apt-get -y purge systemback-scheduler
      sudo apt-get clean
      rm -rf $KALAN_DIR-data/build/sb
    if [[ ! -e $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb ]];then
      if [ ! -d $KALAN_DIR-data/build ];then
          mkdir -p $KALAN_DIR-data/build
      fi
      cp -rf $KALAN_DIR/sw/sb $KALAN_DIR-data/build/sb
      cd $KALAN_DIR-data/build/sb/systemback
      sudo debuild
    fi
    sudo cp -f $KALAN_DIR-data/build/sb/libsystemback_1.7.301_amd64.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-locales_1.7.301_all.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-cli_1.7.301_amd64.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-efiboot-amd64_1.7.301_all.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback-scheduler_1.7.301_amd64.deb /var/cache/apt/archives
    sudo cp -f $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb /var/cache/apt/archives
    
    sudo dpkg -i $KALAN_DIR-data/build/sb/libsystemback_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-locales_1.7.301_all.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-cli_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-efiboot-amd64_1.7.301_all.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback-scheduler_1.7.301_amd64.deb
    sudo dpkg -i $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb

    sudo apt-get -f install
}

if ! [ -x "$(command -v systemback-cli)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   systemback is not installed"
  echo "   We will build it"
  echo "-------------------------------------------------------------------------"
fi

_install_systemback $param1
sudo apt-get -y install --no-install-recommends gnome-panel

sudo apt-get install g++ cmake qtbase5-dev libqt5x11extras5-dev libqt5svg5 libmuparser-dev
git clone --recursive https://github.com/ManuelSchneid3r/albert.git $KALAN_DIR-data/downloads/albert
cd $KALAN_DIR-data/downloads/albert
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make
sudo make install


gsettings set org.gnome.desktop.screensaver idle-activation-enabled false


dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-apps-00-apt-get.fil

echo
echo "Finished"
echo
