#!/bin/bash
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`

if [[ -z $(grep -q "vm.swappiness" /etc/sysctl.conf) ]]; then
   echo "vm.swappiness=10"  >> /etc/sysctl.conf
   echo "Adding path"
fi

if [[ ! -d $KALAN_DIR-data/downloads ]];then
    mkdir -p $KALAN_DIR-data/downloads
fi
if [[ ! -d $KALAN_DIR-data/build ]];then
    mkdir -p $KALAN_DIR-data/build
fi
if [[ -d $KALAN_DIR-data/archives ]];then
    onlyinarchives=$(comm -23 <(ls $KALAN_DIR-data/archives |sort) <(ls /var/cache/apt/archives|sort))
    for line in $onlyinarchives ; do 
            echo "$line" 
            
            echo "Copying $line new from archives"
            sudo cp -rf $KALAN_DIR-data/archives/$line /var/cache/apt/archives/$line
            sudo dpkg -i $KALAN_DIR-data/archives/$line 
    done 
    sudo apt-get -f install
fi

cd $KALAN_DIR-data/downloads

git clone --recursive https://github.com/moka-project/faba-icon-theme.git
cd $KALAN_DIR-data/downloads/faba-icon-theme
git pull
#sudo cp -rf $KALAN_DIR-data/downloads/faba-icon-theme/Faba /usr/share/icons/Faba
sudo rsync -aAXv $KALAN_DIR-data/downloads/faba-icon-theme/Faba/* /usr/share/icons/Faba

cd $KALAN_DIR-data/downloads
git clone --recursive https://github.com/moka-project/moka-icon-theme.git
cd $KALAN_DIR-data/downloads/moka-icon-theme
git pull
#sudo cp -rf $KALAN_DIR-data/downloads/moka-icon-theme/Moka /usr/share/icons/Moka
sudo rsync -aAXv $KALAN_DIR-data/downloads/moka-icon-theme/Moka/* /usr/share/icons/Moka

if [[ ! -e $KALAN_DIR-data/downloads/faenza-icon-theme_1.3.1_all.deb ]];then
  sudo add-apt-repository -y ppa:webupd8team/themes
  sudo apt-get update
  sudo apt-get install -y faenza-icon-theme
  #sudo dpkg -i  $KALAN_DIR-data/downloads/faenza-icon-theme_1.3.1_all.deb
fi

sudo apt-get -y autoremove

sudo apt-get -y install  synaptic aptitude dpkg-dev
sudo apt-get -y install  unity-tweak-tool

sudo apt-get -y install ufw gufw gksu
sudo apt-get -y install quickly 
sudo apt-get -y install preload gparted
#sudo apt-get -y install gnome-session-flashback


sudo cp -a $KALAN_DIR/sw/lubuntu/wallpapers/*.* /usr/share/backgrounds
sudo cp -rf /lib/plymouth/themes/ubuntu-logo /lib/plymouth/themes/ubuntu-logo-orig
sudo cp -a $KALAN_DIR/sw/plymouth/. /lib/plymouth
sudo chmod -R 644 /lib/plymouth/themes/ubuntu-logo
sudo chmod -R 755 /usr/share/backgrounds
sudo chown -R root:root /usr/share/backgrounds
sudo update-initramfs -k all -u
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/kalan-blue.jpg
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop

dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-desktop-apt-get.fil


#dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/desktop-apt-get.fil
#https://atom.io/
echo
echo "Kalan desktop workstation installed."
echo
