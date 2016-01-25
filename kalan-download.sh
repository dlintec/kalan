#!/bin/bash

##### wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i

##### curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i

main() {
PARAMETRO="$1"
wget -N https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh
wget -N https://raw.githubusercontent.com/dlintec/kalan/master/src/kalan-update.sh

chmod +x kalan-download.sh
chmod +x kalan-update.sh
clear
echo "______________________________________________________________________________"
echo " "
echo " "
echo "             Welcome to Kalan Download."
echo "             This script will download and install Kalan Environment "
echo "             You will need admin permissions in this system to install"
echo "             any software required"
echo "=============================================================================="
echo "      Choose : 0-Exit"
echo "               1-Install Host only"
echo "               2-Full Install Host and Workstation"
echo "=============================================================================="
KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
KALAN_VERSION="2.0.0"
#echo "User :$KALAN_USER"
echo "Type an option number an press ENTER to select > "
read response
case $response in
    1)    echo " "
          echo " "
          echo "Installing Host..."
    ;;
    2)    echo " "
          echo " "
          echo "Installing Everything..."
    ;;
    
    *)  echo "Install canceled. ";
        echo "type : './kalan-download.sh' to run this script again"
    	exit;
    ;;
esac

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
  echo "   Git installed: "
  echo "   url -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i"
  echo
fi
if [ -n "$(command -v git)" ]; then
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

    echo "Linking scripts"
    echo "-------------------------------------------------------------------------"
    cd $KALAN_DIR/src/
    prev_path="$PATH"
    ./kregisterscriptsfolder.sh
    ln -sf  $KALAN_DIR/src/kalan-install-all.sh ~/kalan-install-all
    if [ -e ~/.bashrc ];then
        if [[ -z $(grep "~/bin" ~/.bashrc) ]]; then 
           echo "export PATH=$PATH:~/bin"  >> ~/.bashrc
           echo "Adding path"
        fi
    fi
    if [ -e ~/.bash_profile ];then
        if [[ -z $(grep -q "~/bin" ~/.bash_profile) ]]; then
           echo "export PATH=$PATH:~/bin"  >> ~/.bash_profile
           echo "Adding path"
        fi
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
        #mkdir $USER_DESKTOP/kalan-start
        echo
    fi
    filelines=$(ls ~/kalan/start) 
    for line in $filelines ; do 
         #echo "Creando link para script $line" 
         #ln -sf $KALAN_DIR/start/$line  $USER_DESKTOP/kalan-start/$line 
         echo
    done 

    case $response in
        1)  rm -f ~/kalan-download.sh
            echo " "
            echo " "
            echo "Installing Host..."
            $KALAN_DIR/src/kalan-install-host.sh
            exit;
        ;;
        2)  rm -f ~/kalan-download.sh
            echo " "
            echo " "
            echo "Installing Everything..."
            $KALAN_DIR/src/kalan-install-all.sh
            exit;
        ;;
        
        *)  echo "Install canceled. ";
            echo "type : './kalan-download.sh' to start download"
        	exit;
        ;;
    esac

    
    #nautilus $USER_DESKTOP/kalan-start 

    #cp -rf $KALAN_DIR/sw/kalan.desktop ~/.local/share/applications/kalan.desktop
    cd $current_dir
else
   echo
   echo "  You need to install 'git' to download kalan"
fi
}

main "$@"

