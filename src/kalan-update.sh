#!/bin/bash
main() {
   
echo "$0"
param1="$1";shift

KALAN_USER="$(who am i | awk '{print $1}')"
KALAN_DIR="$HOME/kalan"
current_dir=`pwd`
#sudo cp -rf $KALAN_DIR/media/kalan-gray.png /usr/share/backgrounds/kalan-gray.png
echo ""
echo "  |_/ /\ |   /\ |\ | "
echo "  | \/--\|__/--\| \| : Hola $KALAN_USER"
echo ""

echo "  We need your superuser powers to update"
echo ""
sudo echo "  If sudo succeds your are in..."

source $KALAN_DIR/src/kalan-lib.sh

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
  echo "   curl -L https://raw.githubusercontent.com/dlintec/kalan/master/kalan-download.sh | bash -i"
  echo
fi
if [ -n "$(command -v git)" ]; then
   if [ ! -e $KALAN_DIR/README.md ];then
      git clone --recursive https://github.com/dlintec/kalan.git $KALAN_DIR
   fi
   cd $KALAN_DIR
   git fetch --all
   git reset --hard origin/master
   git pull
   chmod -R 770 $KALAN_DIR/src
   chmod +x $KALAN_DIR/src/kalan.sh
   chmod +x $KALAN_DIR/src/kregisterscript.sh
   chmod +x $KALAN_DIR/src/kregisterscriptsfolder.sh
   chmod -R 775 $KALAN_DIR/media
   
   
   if [[ ! -d /usr/local/share/kalan ]];then
     sudo mkdir -p /usr/local/share/kalan
   fi
   if [[ ! -d ~/bin ]];then
     mkdir -p ~/bin
   fi
   $KALAN_DIR/src/kregisterscriptsfolder.sh

   sudo cp -rf $KALAN_DIR/media/kalan*.* /usr/local/share/kalan
   
   sudo cp -a $KALAN_DIR/sw/lubuntu/wallpapers/*.* /usr/share/backgrounds
   sudo chmod -R 755 /usr/share/backgrounds
   sudo chmod -R 755 $KALAN_DIR/src/kalan-update.sh
   sudo chown -R root:root /usr/share/backgrounds
   sudo cp -a $KALAN_DIR/sw/*.desktop /usr/share/applications/
   sudo chmod -R 755 /usr/share/applications/kalan-update.desktop
   sudo cp -a /usr/share/applications/kalan-update.desktop $HOME/Desktop/
   sudo chmod -R 755 $HOME/Desktop/kalan-update.desktop
   sudo cp -a $KALAN_DIR/src/kalan-update.sh /usr/local/bin/
   gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/kalan-blue.jpg
   if [[ ! -d $KALAN_DIR-data/sw/updates ]];then
     mkdir -p $KALAN_DIR-data/sw/updates
     echo "echo 'added by kalan-update on first update'" >> $KALAN_DIR-data/sw/updates/update_init.kup

   fi

   if [[ ! -e $KALAN_DIR-data/conf/applied-updates ]];then
      echo "First update" > $KALAN_DIR-data/conf/applied-updates
   fi
   $KALAN_DIR/src/kalan-personalize-xfce.sh
   $KALAN_DIR/src/kconfigautostart.sh
   echo "listing updates..."
   updates_applied=0
   updates_avail=$(ls $KALAN_DIR-data/sw/updates)
   if [[ -n "$updates_avail" ]];then
         source easybashgui
         for line in $updates_avail ; do
             echo "Creating link for script $line"
             if grep "$line" "$KALAN_DIR-data/conf/applied-updates"; then
                  echo "already applied:$line"
             else
                  updescription=$(sed -n '2p' $KALAN_DIR-data/sw/updates/$line)
                  question -w 300 -h 200 "kalan update $line is available. $updescription Do you want to install it now?" 
                  answer="${?}" 
                  if [ ${answer} -eq 0 ]; then
                          echo "new update:$line"
                          chmod +x $KALAN_DIR-data/sw/updates/$line
                          $KALAN_DIR-data/sw/updates/$line
                           if [ $? -eq 0 ]; then
                              current_time=$(date "+%Y.%m.%d-%H.%M.%S")
                              echo "#$current_time" >> $KALAN_DIR-data/conf/applied-updates
                              echo "$line" >> $KALAN_DIR-data/conf/applied-updates
                              updates_applied=updates_applied+1
                           fi
         
                  elif [ ${answer} -eq 1 ];then 
                     alert_message -w 300 -h 200 "No update installed :(" 
                  else 
                     ok_message -w 300 -h 200 "Why didn't you answer?\nSee you..." 
                  fi

             fi
         done
         ok_message -w 300 -h 200 "$updates_applied updates installed :)" 
            
   fi
else
   echo
   echo "  You need to install 'git' to download kalan"
fi

}

main "$@"
