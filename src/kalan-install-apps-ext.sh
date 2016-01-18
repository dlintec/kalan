#!/bin/bash 
 
 
KALAN_USER="$(who am i | awk '{print $1}')" 
KALAN_DIR="$HOME/kalan" 
source $KALAN_DIR/src/kalan-lib.sh 
PACKAGE_MANAGER=$(get_package_manager)  
current_dir=`pwd`  


#sudo apt-get -y install virtualbox  



