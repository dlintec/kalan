#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

sudo add-apt-repository -y ppa:docky-core/stable
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install plank

#sudo apt-get -y install --no-install-recommends gnome-panel
sudo apt-get -y install g++ cmake qtbase5-dev libqt5x11extras5-dev libqt5svg5 libmuparser-dev libqt5gui5 libqt5widgets5
sudo apt-get -y install devscripts lupin-casper squashfs-tools debhelper libblkid-dev libmount-dev libncursesw5-dev libparted0-dev

sudo apt-get -y install qttools5-dev-tools


git clone --recursive https://github.com/ManuelSchneid3r/albert.git $KALAN_DIR-data/downloads/albert
cd $KALAN_DIR-data/downloads/albert
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make
sudo make install

#add/remove to startup applications
#/usr/bin/vmware-user-suid-wrapper

function _install_systemback () {
      echo "removing"

      sudo dpkg -r systemback
      sudo dpkg -r  libsystemback
      sudo dpkg -r  systemback-locales
      sudo dpkg -r  systemback-cli
      sudo dpkg -r  systemback-efiboot
      sudo dpkg -r  systemback-scheduler
      sudo apt-get clean
      sudo apt-get autoclean
      sudo rm -rf $KALAN_DIR-data/build/sb
      #if [[ ! -e $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb ]];then
      if [ ! -d $KALAN_DIR-data/build ];then
          mkdir -p $KALAN_DIR-data/build
      fi
      cp -rf $KALAN_DIR/sw/sb $KALAN_DIR-data/build/sb
      cd $KALAN_DIR-data/build/sb/systemback
      sudo debuild
      #fi
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




gsettings set org.gnome.desktop.screensaver idle-activation-enabled false


dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-apps-00-apt-get.fil

echo
echo "Finished"
echo
