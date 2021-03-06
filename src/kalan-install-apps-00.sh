#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

sudo apt-get -y update
sudo apt-get -y upgrade

#sudo apt-get -y install --no-install-recommends gnome-panel
sudo apt-get -y install  g++ cmake gksu syslinux
sudo apt-get -y install libmuparser-dev 
sudo apt-get -y install libqt5widgets5 libgles2-mesa-dev libqt5x11extras5-dev libqt5gui5 libqt5svg5 libqt5designer5 libqt5designercomponents5 libqt5help5 libqt5printsupport5 
sudo apt-get -y install qtbase5-dev
sudo apt-get -y install devscripts lupin-casper squashfs-tools debhelper libblkid-dev libmount-dev libncursesw5-dev libparted0-dev

sudo apt-get -y install qttools5-dev-tools


git clone --recursive https://github.com/ManuelSchneid3r/albert.git $KALAN_DIR-data/downloads/albert
cd $KALAN_DIR-data/downloads/albert
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make
sudo make install
sudo apt-get -y -f install
sudo apt-get -y upgrade
#add/remove to startup applications
#/usr/bin/vmware-user-suid-wrapper

function _install_systemback () {
      echo "removing"

      sudo dpkg -r systemback
      #sudo dpkg -r  libsystemback
      #sudo dpkg -r  systemback-locales
      #sudo dpkg -r  systemback-cli
      #sudo dpkg -r  systemback-efiboot
      #sudo dpkg -r  systemback-scheduler
      sudo apt-get clean
      sudo apt-get autoclean
      #sudo rm -rf $KALAN_DIR-data/build/sb
      #if [[ ! -e $KALAN_DIR-data/build/sb/systemback_1.7.301_amd64.deb ]];then
      sbver="systemback_1.7.302"

      if [ ! -d $KALAN_DIR-data/build/sb_kalan/$sbver ];then
            mkdir -p $KALAN_DIR-data/build/sb_kalan
            cp $KALAN_DIR/sw/systemback_1.7.302_source.tar.xz $KALAN_DIR-data/build/sb_kalan/
            cd  $KALAN_DIR-data/build/sb_kalan
            tar -xJf systemback_1.7.302_source.tar.xz 
            cp -a $KALAN_DIR/sw/systemback/. $KALAN_DIR-data/build/sb_kalan/$sbver/
            cd $KALAN_DIR-data/build/sb_kalan/$sbver
            sudo debuild
            #fi
      fi
      
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/systemback_1*.deb /var/cache/apt/archives
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/libsystemback*.deb /var/cache/apt/archives
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/systemback-locales*.deb /var/cache/apt/archives
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/systemback-cli*.deb /var/cache/apt/archives
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/systemback-efiboot-amd64*.deb /var/cache/apt/archives
            #sudo cp -f $KALAN_DIR-data/build/sb_kalan/systemback-scheduler*.deb /var/cache/apt/archives
            
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/libsystemback*.deb
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/systemback-locales*.deb
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/systemback-cli*.deb
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/systemback-efiboot-amd64*.deb
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/systemback-scheduler*.deb
            sudo dpkg -i $KALAN_DIR-data/build/sb_kalan/systemback*.deb
      
      #sudo apt-get -f install
      sudo mv /etc/xdg/autostart/sbschedule* $KALAN_DIR/sw/systemback/
      sudo apt-get -y -f install
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
