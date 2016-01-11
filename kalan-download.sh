#!/bin/bash

# wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i
# curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i

PARAMETRO="$1"

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
KALAN_VERSION="2.0.0"
echo "Usuario :$KALAN_USER"

current_dir=`pwd`
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
PACKAGE_MANAGER="yum"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACKAGE_MANAGER=${osInfo[$f]}
        echo $PACKAGE_MANAGER
    fi
done
#$PACKAGE_MANAGER -y install git curl
if ! [ -x "$(command -v git)" ]; then
  echo "-------------------------------------------------------------------------"
  echo "   Git is not installed"
  echo "   We will use: sudo $PACKAGE_MANAGER install git"
  echo "-------------------------------------------------------------------------"
 
  sudo apt-get -y install git
  echo "   Git installed, try again: "
  echo "   url -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i"
  echo
fi
if [ -x "$(command -v git)" ]; then
    export PACKAGE_MANAGER="$PACKAGE_MANAGER"
    if [ ! -e $KALAN_DIR/README.md ];then
        echo "Cloning new..."
       git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
    else
        echo "pull"
      cd $KALAN_DIR
      git pull

    fi

    chmod -R 770 $KALAN_DIR/src

    source $KALAN_DIR/src/kalan-lib.sh

    echo "Creando scripts"
    echo "-------------------------------------------------------------------------"
    cd $KALAN_DIR/src/
    ./kregisterscriptsfolder.sh
    if [[ ! grep -q PATH=~/kalan/bin "~/.bashrc" ]]; then
       echo "export PATH=~/kalan/bin:$PATH"  >> ~/.bashrc
       echo "Adding path"
    fi
    if [[ ! grep -q PATH=~/kalan/bin "~/.bash_profile" ]]; then
       echo "export PATH=~/kalan/bin:$PATH"  >> ~/.bash_profile
       echo "Adding path"
    fi

    . ~/.bashrc

    USER_DESKTOP="$(xdg-user-dir DESKTOP)"
    if [[ ( -n "$USER_DESKTOP" ) && ( ! -d $USER_DESKTOP ) ]];then
        if [[ -d $HOME/desktop ]];then
            USER_DESKTOP="$HOME/desktop"
        fi
        if [[ -d $HOME/Desktop ]];then
            USER_DESKTOP="$HOME/Desktop"
        fi
        
        if [[ -d $HOME/Escritorio ]];then
            USER_DESKTOP="$HOME/Escritorio"
        fi
    fi  

    #cp -rf $KALAN_DIR/bin/kalan-install-host $USER_DESKTOP/kalan/install-host
    #cp -rf $KALAN_DIR/bin/kalan-install-desktop $USER_DESKTOP/kalan/install-desktop
    if [[ ! -d $USER_DESKTOP/kalan-start ]];then
        mkdir $USER_DESKTOP/kalan-start
    fi
   filelines=$(ls ~/kalan/src) 
    for line in $filelines ; do 
         #echo "Creando link para script $line" 
         ln -sf $KALAN_DIR/start/$line  $USER_DESKTOP/kalan/$line 
    done 

    
    nautilus $USER_DESKTOP/kalan-start 

    cp -rf $KALAN_DIR/sw/kalan.desktop ~/.local/share/applications/kalan.desktop
    cd $current_dir
fi



